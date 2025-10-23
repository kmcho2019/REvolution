module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state; // previous state of the input vector
reg [7:0] pedge_reg;  // register for the output

always @(posedge clk) begin
    // update the previous state
    prev_state <= in;
    // set the output bit to 1 if a 0 to 1 transition occurs
    for (int i = 0; i < 8; i++) begin
        if (prev_state[i] == 0 && in[i] == 1) begin
            pedge_reg[i] <= 1'b1;
        end else begin
            pedge_reg[i] <= 1'b0;
        end
    end
end

assign pedge = pedge_reg;

endmodule