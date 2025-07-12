module TopModule(
    input       clk,
    input       reset,
    input       slowena,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else if (slowena) begin
        count <= next_count;
    end
end

always @(*) begin
    if (count == 4'd9) begin
        next_count = 4'b0;
    end else begin
        next_count = count + 1'b1;
    end
end

assign q = count;

endmodule