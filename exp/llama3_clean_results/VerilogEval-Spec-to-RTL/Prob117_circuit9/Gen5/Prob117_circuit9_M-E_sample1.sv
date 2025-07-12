module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @ (posedge clk) begin
    if (a) begin
        q <= 4; // Reset to 4 when 'a' is 1
    end else begin
        if (q >= 5) begin
            q <= 0; // Reset to 0 when 'q' reaches or exceeds 5 and 'a' is 0
        end else begin
            q <= q + 1; // Increment 'q' when 'a' is 0 and 'q' is less than 5
        end
    end
end

endmodule