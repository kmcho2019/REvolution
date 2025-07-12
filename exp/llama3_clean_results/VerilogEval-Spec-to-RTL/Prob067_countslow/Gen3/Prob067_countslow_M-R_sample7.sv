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
    end else begin
        reg [3:0] next_count;
        assign next_count = (count == 4'd9 && slowena) ? 4'b0000 : (slowena) ? count + 1'b1 : count;
        count <= next_count;
    end
end

assign q = count;

endmodule