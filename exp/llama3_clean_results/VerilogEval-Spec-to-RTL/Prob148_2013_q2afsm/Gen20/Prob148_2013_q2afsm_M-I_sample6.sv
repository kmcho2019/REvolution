module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [3:0] state; // One-hot encoding for states A, B, C, D

always @(posedge clk) begin
    if (~resetn) state <= 4'b0001; // Reset to state A
    else begin
        case (1'b1)
            state[0]: // State A
                state <= (r[0]) ? 4'b0010 : (r[1]) ? 4'b0100 : (r[2]) ? 4'b1000 : 4'b0001;
            state[1]: // State B
                state <= (r[0]) ? 4'b0010 : 4'b0001;
            state[2]: // State C
                state <= (r[1]) ? 4'b0100 : 4'b0001;
            state[3]: // State D
                state <= (r[2]) ? 4'b1000 : 4'b0001;
            default: state <= 4'b0001;
        endcase
    end
end

assign g[0] = state[1]; // Grant for device 0
assign g[1] = state[2]; // Grant for device 1
assign g[2] = state[3]; // Grant for device 2

endmodule