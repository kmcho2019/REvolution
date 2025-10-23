module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] count;

initial begin
    q = 1'b1;
    count = 2'b00;
end

always @(posedge clk) begin
    if (a) begin
        count <= count + 1;
    end else begin
        count <= 2'b00;
    end
    
    if (count == 2'b10) begin
        q <= ~q;
    end
end

endmodule