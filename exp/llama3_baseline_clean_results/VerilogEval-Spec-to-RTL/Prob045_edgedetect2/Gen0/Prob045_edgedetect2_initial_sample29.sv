module TopModule(
    input       clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store the previous input value

// sequential logic to update the previous input value
always @(posedge clk) begin
    prev_in <= in;
end

// combinational logic to detect any edge and generate output
assign anyedge = in ^ prev_in;

endmodule