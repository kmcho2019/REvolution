module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter = 0;

always @(posedge clk) begin
    if (a == 1'b1) begin
        // hold the counter value
    end else begin
        counter = counter + 1'b1;
    end
end

always @(posedge clk) begin
    if ($time == 5) begin
        counter = 4;
    end
end

assign q = counter;

endmodule