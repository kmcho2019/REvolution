module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous input
reg [7:0] anyedge_reg; // internal register for output

always @ (posedge clk) begin
    // store current input for next cycle
    prev_in <= in;

    // calculate output based on current input and previous input
    for (int i = 0; i < 8; i++) begin
        if (in[i] != prev_in[i]) begin
            anyedge_reg[i] <= 1'b1;
        end else begin
            anyedge_reg[i] <= 1'b0;
        end
    end
end

assign anyedge = anyedge_reg;

initial begin
    prev_in = 8'b0; // initialize previous input
    anyedge_reg = 8'b0; // initialize output
end

endmodule