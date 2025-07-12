module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count = 0;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (slowena && (count < 10)) begin
        count <= count + 1;
    end
end

assign q = count;

endmodule