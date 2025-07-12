module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot encoding for states
reg [3:0] state; // A, B, C, D

// Next state logic using one-hot encoding
always @(posedge clk) begin
    if (~resetn) state <= 4'b0001; // Reset to state A
    else begin
        case (1'b1) // One-hot decoding
            state[0]: // State A
                if (r[0]) state <= 4'b0010;
                else if (r[1]) state <= 4'b0100;
                else if (r[2]) state <= 4'b1000;
                else state <= 4'b0001;
            state[1]: // State B
                if (r[0]) state <= 4'b0010;
                else state <= 4'b0001;
            state[2]: // State C
                if (r[1]) state <= 4'b0100;
                else state <= 4'b0001;
            state[3]: // State D
                if (r[2]) state <= 4'b1000;
                else state <= 4'b0001;
            default: state <= 4'b0001;
        endcase
    end
end

// Output assignments
assign g[0] = state[1]; // State B
assign g[1] = state[2]; // State C
assign g[2] = state[3]; // State D

endmodule