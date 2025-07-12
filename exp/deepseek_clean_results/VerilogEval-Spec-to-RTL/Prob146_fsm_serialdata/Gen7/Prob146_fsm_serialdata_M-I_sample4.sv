module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state, next_state;
    reg [7:0] bit_counter;  // One-hot encoded counter for RECEIVE state
    reg [7:0] shift_reg;
    reg shift_enable;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 8'b00000001;
            shift_reg <= 0;
            shift_enable <= 0;
        end else begin
            state <= next_state;
            
            // Shift register with enable
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
            end
            
            // One-hot counter for RECEIVE state
            if (state == RECEIVE) begin
                bit_counter <= {bit_counter[6:0], bit_counter[7]};
            end else begin
                bit_counter <= 8'b00000001;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
                shift_enable = 0;
            end
            
            RECEIVE: begin
                shift_enable = 1;
                if (bit_counter[7]) begin  // All 8 bits received
                    next_state = STOP;
                end else begin
                    next_state = RECEIVE;
                end
            end
            
            STOP, ERROR: begin
                shift_enable = 0;
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            
            default: begin
                next_state = IDLE;
                shift_enable = 0;
            end
        endcase
    end

    // Output logic (separate from state machine to reduce critical path)
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;
            if ((state == STOP || state == ERROR) && in == 1) begin
                out_byte <= shift_reg;
                done <= 1;
            end
        end
    end

endmodule