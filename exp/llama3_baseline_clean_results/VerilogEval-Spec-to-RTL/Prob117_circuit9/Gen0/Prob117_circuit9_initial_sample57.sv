module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

integer previous_a;

always @(posedge clk) begin
    if (~previous_a && a) begin
        q <= 4;
    end
    else if (~a) begin
        q <= q + 1;
        if (q == 7) begin
            q <= 0;
        end
    end
end

always @(posedge clk) begin
    previous_a <= a;
end

initial begin
    previous_a = 1'b0;
    q = 4;
end

endmodule