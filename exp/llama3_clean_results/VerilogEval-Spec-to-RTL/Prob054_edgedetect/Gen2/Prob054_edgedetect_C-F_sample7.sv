module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in
reg [7:0] pedge_reg; // register to store the output

always @(posedge clk) begin
    prev_in <= in; // update the previous value on every clock cycle
    for (int i = 0; i < 8; i++) begin
        pedge_reg[i] <= in[i] && (!prev_in[i]); // detect positive edge transition using bitwise AND
    end
end

assign pedge = pedge_reg; // assign the output

endmodule