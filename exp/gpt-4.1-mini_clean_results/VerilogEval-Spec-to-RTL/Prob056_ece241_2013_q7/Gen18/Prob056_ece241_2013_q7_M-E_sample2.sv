module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0)
        Q <= Q;         // hold current state
    else if (j == 0 && k == 1)
        Q <= 1'b0;      // reset
    else if (j == 1 && k == 0)
        Q <= 1'b1;      // set
    else // j == 1 && k == 1
        Q <= ~Q;       // toggle
end

endmodule