module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (~a) begin
        if (counter < 6) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end
end

always @(*) begin
    if (a) begin
        q = 4;
    end else begin
        q = counter;
    end
end

endmodule