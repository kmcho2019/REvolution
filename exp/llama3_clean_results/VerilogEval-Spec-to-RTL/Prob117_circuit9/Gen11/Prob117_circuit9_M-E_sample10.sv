module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (a) begin
        counter <= 4;
    end else if (counter == 6) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

always @(*) begin
    q = counter;
end

endmodule