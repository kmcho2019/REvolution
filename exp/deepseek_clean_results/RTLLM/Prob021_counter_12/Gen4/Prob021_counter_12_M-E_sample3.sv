module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

// One-hot state encoding (12 states)
reg [11:0] state;

// Next state computation (parallel)
wire [11:0] next_state;
assign next_state[0] = (!rst_n) ? 1'b1 : (state[11] & valid_count) ? 1'b1 : 1'b0;
assign next_state[1] = (!rst_n) ? 1'b0 : (state[0] & valid_count) ? 1'b1 : 1'b0;
assign next_state[2] = (!rst_n) ? 1'b0 : (state[1] & valid_count) ? 1'b1 : 1'b0;
assign next_state[3] = (!rst_n) ? 1'b0 : (state[2] & valid_count) ? 1'b1 : 1'b0;
assign next_state[4] = (!rst_n) ? 1'b0 : (state[3] & valid_count) ? 1'b1 : 1'b0;
assign next_state[5] = (!rst_n) ? 1'b0 : (state[4] & valid_count) ? 1'b1 : 1'b0;
assign next_state[6] = (!rst_n) ? 1'b0 : (state[5] & valid_count) ? 1'b1 : 1'b0;
assign next_state[7] = (!rst_n) ? 1'b0 : (state[6] & valid_count) ? 1'b1 : 1'b0;
assign next_state[8] = (!rst_n) ? 1'b0 : (state[7] & valid_count) ? 1'b1 : 1'b0;
assign next_state[9] = (!rst_n) ? 1'b0 : (state[8] & valid_count) ? 1'b1 : 1'b0;
assign next_state[10] = (!rst_n) ? 1'b0 : (state[9] & valid_count) ? 1'b1 : 1'b0;
assign next_state[11] = (!rst_n) ? 1'b0 : (state[10] & valid_count) ? 1'b1 : 1'b0;

// State register with clock enable
always @(posedge clk) begin
    if (!rst_n) begin
        state <= 12'b000000000001; // State 0
    end else if (valid_count) begin
        state <= next_state;
    end
end

// Output generation (pre-decoded)
always @(*) begin
    case (1'b1)
        state[0]: out = 4'b0000;
        state[1]: out = 4'b0001;
        state[2]: out = 4'b0010;
        state[3]: out = 4'b0011;
        state[4]: out = 4'b0100;
        state[5]: out = 4'b0101;
        state[6]: out = 4'b0110;
        state[7]: out = 4'b0111;
        state[8]: out = 4'b1000;
        state[9]: out = 4'b1001;
        state[10]: out = 4'b1010;
        state[11]: out = 4'b1011;
        default: out = 4'b0000;
    endcase
end

endmodule