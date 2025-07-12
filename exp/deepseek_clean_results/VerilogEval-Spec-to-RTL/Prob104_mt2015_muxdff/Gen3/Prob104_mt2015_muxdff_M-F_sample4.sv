module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire D = L ? r_in : q_in;

    always @(posedge clk)
        Q <= D;

endmodule