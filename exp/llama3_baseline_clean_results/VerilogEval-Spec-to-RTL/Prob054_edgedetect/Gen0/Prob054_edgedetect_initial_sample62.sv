module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store previous state of 'in'
reg [7:0] pedge_reg; // register to store output 'pedge'

always @ (posedge clk) begin
    prev_in <= in; // update previous state of 'in' on rising edge of 'clk'
    for (int i = 0; i < 8; i++) begin
        // check if bit i of 'in' has changed from 0 to 1
        if (~prev_in[i] && in[i]) begin
            pedge_reg[i] <= 1'b1; // set bit i of 'pedge' to 1 if transition detected
        end else begin
            pedge_reg[i] <= 1'b0; // set bit i of 'pedge' to 0 if no transition detected
        end
    end
end

assign pedge = pedge_reg; // assign output 'pedge' from register

initial begin
    prev_in = 8'b0; // initialize previous state of 'in' to 0
    pedge_reg = 8'b0; // initialize output 'pedge' to 0
end

endmodule