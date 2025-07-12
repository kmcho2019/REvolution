module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // internal signal to store the previous state of in
reg [7:0] pedge_reg; // internal signal to store the output

always @(posedge clk) begin
    // detect rising edge for each bit
    for (int i = 0; i < 8; i++) begin
        if (prev_in[i] == 0 && in[i] == 1) begin
            pedge_reg[i] <= 1'b1;
        end else begin
            pedge_reg[i] <= 1'b0;
        end
    end
    prev_in <= in; // update the previous state
end

assign pedge = pedge_reg; // assign the output

endmodule