module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP   = 4'b0100;
    localparam ERROR  = 4'b1000;

    reg [3:0] state, next_state;
    reg [7:0] bit_counter;  // One-hot encoded counter for 8 bits
    reg [7:0] shift_reg;
    reg shift_enable;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 8'b00000001;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
            end
            
            if (state == RECEIVE) begin
                bit_counter <= {bit_counter[6:0], bit_counter[7]};  // Rotate one-hot
            end else begin
                bit_counter <= 8'b00000001;  // Reset counter
            end
        end
    end

    // Separate done signal generation
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
        end else begin
            done <= (state == STOP && in == 1) || (state == ERROR && in == 1);
            if ((state == STOP || state == ERROR) && in == 1) begin
                out_byte <= shift_reg;
            end
        end
    end

    // FSM next state logic and shift enable
    always @(*) begin
        shift_enable = 0;
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                shift_enable = 1;
                next_state = (bit_counter == 8'b10000000) ? STOP : RECEIVE;
            end
            
            STOP: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            ERROR: begin
                next_state = (in == 1) ? IDLE : ERROR;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule