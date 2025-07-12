module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (a) begin
        q <= 4;
        counter <= 0;
    end else begin
        if (counter < 6) begin
            q <= counter + 1;
            counter <= counter + 1;
        end else begin
            q <= 0;
            counter <= 0;
        end
    end
end

initial q = 4;

endmodule