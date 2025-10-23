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
    reg [3:0] bit_count;  // One-hot encoded counter (bits 0-7)
    reg [7:0] shift_reg;
    reg shift_enable;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'b0001;  // Start at bit 0
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            
            if (shift_enable) begin
                shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
            end
            
            // One-hot counter update
            if (state == RECEIVE) begin
                bit_count <= {bit_count[2:0], bit_count[3]};  // Rotate left
            end else begin
                bit_count <= 4'b0001;  // Reset to bit 0
            end
        end
    end

    // Done signal generation (separate from state logic)
    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
        end else begin
            done <= (state == STOP) && (in == 1);
            if (done) begin
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
                next_state = (bit_count[3]) ? STOP : RECEIVE;  // After 8 bits
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