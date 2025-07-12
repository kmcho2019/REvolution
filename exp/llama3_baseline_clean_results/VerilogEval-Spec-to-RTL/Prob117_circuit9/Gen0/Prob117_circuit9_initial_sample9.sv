module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (~a) begin
        q <= q + 1;
        if (q == 7) begin
            q <= 0;
        end
    end
end

initial begin
    q = 4;  // Initial value of q as per the simulation waveforms
end

endmodule