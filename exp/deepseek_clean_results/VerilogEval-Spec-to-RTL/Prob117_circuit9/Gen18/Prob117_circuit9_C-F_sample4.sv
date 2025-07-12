module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Set to 4 when a is high
    end else if (q == 3'b110) begin
        q <= 3'b000;  // Reset to 0 after 6
    end else begin
        q <= q + 1'b1;  // Increment otherwise
    end
end

endmodule