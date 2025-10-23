module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of in
reg [7:0] pedge_reg; // register to store the output pedge

always @ (posedge clk) begin
    prev_in <= in; // update the previous value of in at every clock cycle
    pedge_reg <= 8'b0; // reset pedge_reg at every clock cycle
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1 && prev_in[i] == 0) begin
            pedge_reg[i] <= 1; // set the output bit if a 0 to 1 transition is detected
        end
    end
end

assign pedge = pedge_reg; // assign the output pedge

endmodule