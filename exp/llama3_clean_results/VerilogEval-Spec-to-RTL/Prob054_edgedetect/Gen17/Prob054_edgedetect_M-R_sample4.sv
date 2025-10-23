module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
end

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign pedge[i] = in[i] && ~prev_in[i];  // detect 0 to 1 transition using bitwise AND
    end
endgenerate

endmodule