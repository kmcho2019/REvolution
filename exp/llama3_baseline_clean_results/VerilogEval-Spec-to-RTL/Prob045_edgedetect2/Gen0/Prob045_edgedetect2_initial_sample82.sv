module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous input value
reg [7:0] anyedge_reg; // internal register for output

always @ (posedge clk) begin
    anyedge_reg <= 0; // default output to 0
    for (int i = 0; i < 8; i++) begin
        if (in[i] != prev_in[i]) begin
            anyedge_reg[i] <= 1'b1; // set output to 1 if edge is detected
        end
    end
    prev_in <= in; // update previous input value
end

assign anyedge = anyedge_reg; // continuous assignment of internal reg to output

initial begin
    prev_in = 0; // initialize previous input value to 0
    anyedge_reg = 0; // initialize internal output reg to 0
end

endmodule