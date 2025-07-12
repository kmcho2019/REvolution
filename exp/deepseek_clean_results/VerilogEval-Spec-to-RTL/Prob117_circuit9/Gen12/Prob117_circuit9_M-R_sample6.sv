module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (a) begin
        counter <= 3'd4;
    end else begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 3'd1;
    end
end

assign q = counter;

endmodule