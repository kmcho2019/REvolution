module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter = 3'd4;  // Initialize to 4

always @(posedge clk) begin
    if (a) begin
        counter <= 3'd4;
    end else begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 1;
    end
end

assign q = a ? 3'd4 : counter;

endmodule