module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous state of in
reg [7:0] pedge_reg; // register to store the output

always @ (posedge clk) begin
    // update the previous state of in
    prev_in <= in;
    
    // detect rising edges and update pedge_reg
    pedge_reg <= ~(prev_in) & in;
end

// assign the output
assign pedge = pedge_reg;

endmodule