module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

initial Q = 1'b0; // Initialize Q to known state for simulation

always @(posedge clk) begin
    if (L)
        Q <= r_in;
    else
        Q <= q_in;
end

endmodule