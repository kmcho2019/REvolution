module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (slowena) begin
        count <= (count == 4'd9) ? 4'b0000 : count + 4'b0001;
    end
end

assign q = count;

endmodule