module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

always @(posedge clk) begin
    if (~a) begin
        q_reg = (q_reg == 3'b111) ? 3'b000 : q_reg + 1'b1;
    end
end

assign q = q_reg;

initial begin
    q_reg = 3'b100; // initialize q_reg to 4 (as seen in the simulation waveforms)
end

endmodule