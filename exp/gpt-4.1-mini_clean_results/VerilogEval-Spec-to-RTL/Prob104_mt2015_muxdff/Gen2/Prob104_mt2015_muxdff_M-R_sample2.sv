module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

always @(posedge clk) begin
    reg mux_out;
    mux_out = L ? r_in : q_in;  // combinational mux logic inside clocked block
    Q <= mux_out;               // register assignment
end

endmodule