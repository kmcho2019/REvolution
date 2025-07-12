module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store previous state
reg [7:0] pedge_reg;  // register to store output

always @(posedge clk) begin
    prev_in <= in;  // update previous state at each clock cycle
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge_reg[i] <= 1;  // set output bit if 0 to 1 transition occurs
        end else begin
            pedge_reg[i] <= 0;  // reset output bit otherwise
        end
    end
end

assign pedge = pedge_reg;  // assign output register to output port

endmodule