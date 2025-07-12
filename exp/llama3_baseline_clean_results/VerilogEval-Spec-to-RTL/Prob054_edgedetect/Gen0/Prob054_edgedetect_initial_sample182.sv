module TopModule (
    input  clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] in_prev; // internal register to store previous input value
reg [7:0] pedge;   // output register

always @(posedge clk) begin
    // detect positive edge transition and assign to output
    pedge <= ~in_prev & in;
    // update internal register with current input value
    in_prev <= in;
end

endmodule