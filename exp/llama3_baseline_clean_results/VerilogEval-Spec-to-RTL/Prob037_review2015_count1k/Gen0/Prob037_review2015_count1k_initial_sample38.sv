module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 10'd0;
    end else if (counter == 10'd999) begin
        counter <= 10'd0;
    end else begin
        counter <= counter + 1;
    end
end

assign q = counter;

endmodule