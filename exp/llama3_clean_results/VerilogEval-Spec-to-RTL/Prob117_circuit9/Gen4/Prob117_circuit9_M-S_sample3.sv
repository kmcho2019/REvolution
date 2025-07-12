module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @ (posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when 'a' is 1
    end else begin
        q <= (q == 7) ? 0 : q + 1; // Increment 'q' when 'a' is 0, wrap around to 0 when 'q' reaches 7
    end
end

endmodule