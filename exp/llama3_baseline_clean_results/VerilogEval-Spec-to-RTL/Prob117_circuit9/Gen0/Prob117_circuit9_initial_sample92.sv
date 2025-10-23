module TopModule(
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if (~a) begin
        count <= count + 1;
    end
end

assign q = count;

initial begin
    count = 4'd4; // Initialize count to match the initial value in the waveform
end

endmodule