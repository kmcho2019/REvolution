module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
        q <= 4'b0000;
    end
    else begin
        counter <= counter + 1'b1;
        q <= counter + 1'b1;  // Registered output with lookahead
    end
end

endmodule