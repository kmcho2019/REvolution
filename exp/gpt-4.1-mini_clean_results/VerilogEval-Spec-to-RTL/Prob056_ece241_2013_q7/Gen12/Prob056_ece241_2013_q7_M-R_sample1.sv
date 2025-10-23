module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

reg next_Q;

always @(*) begin
    case ({j, k})
        2'b00: next_Q = Q;       // Hold state
        2'b01: next_Q = 1'b0;    // Reset
        2'b10: next_Q = 1'b1;    // Set
        2'b11: next_Q = ~Q;      // Toggle
        default: next_Q = Q;
    endcase
end

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule