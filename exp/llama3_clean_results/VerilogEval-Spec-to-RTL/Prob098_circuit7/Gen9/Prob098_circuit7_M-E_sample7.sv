module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] counter;

always @(posedge clk) begin
    if (a) begin
        counter <= counter + 1;
        q <= 0;
    end else if (counter == 0) begin
        q <= 1;
    end else begin
        counter <= counter - 1;
        q <= 0;
    end
end

endmodule