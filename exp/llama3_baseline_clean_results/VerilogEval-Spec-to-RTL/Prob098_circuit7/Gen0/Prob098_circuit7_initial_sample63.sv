module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if(a) begin
        q <= ~q;
    end
end

initial begin
    q = 1'b1; // initialize q to 1 as per the given simulation waveforms
end

endmodule