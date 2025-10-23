module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg;
assign q = q_reg;

initial begin
    q_reg = 1'b1; // Initial value based on the simulation waveforms provided
end

always @(posedge clk) begin
    if (q_reg == 1'b1 && a == 1'b1) begin
        q_reg = 1'b0;
    end
end

endmodule