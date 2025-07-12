module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in; // register to store previous input
reg [31:0] out_reg; // register to store output

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'd0; // reset output register when reset is high
    end else begin
        prev_in <= in; // store current input for next cycle
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1; // capture 1 to 0 transition
            end
        end
    end
end

assign out = out_reg;

endmodule