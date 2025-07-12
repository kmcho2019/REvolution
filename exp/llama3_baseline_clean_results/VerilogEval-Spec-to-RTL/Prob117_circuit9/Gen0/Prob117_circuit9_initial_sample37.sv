module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (~a) begin
        q <= q + 1;
    end
end

initial begin
    q <= 4; // Initial value as observed in the simulation waveforms
end

endmodule