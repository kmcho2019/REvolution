module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end
    else begin
        counter <= counter + 1'b1;
    end
end

assign q = counter;

endmodule