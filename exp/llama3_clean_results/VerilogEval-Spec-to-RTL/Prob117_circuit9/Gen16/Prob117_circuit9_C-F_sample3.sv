module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 4; // Reset to 4 when a is high
    end else begin
        if (q == 6) begin
            next_q = 0; // Wrap around to 0 if q is 6
        end else begin
            next_q = q + 1; // Increment q by 1
        end
    end
end

always @(posedge clk) begin
    q <= next_q;
end

initial q = 4; // Initialize q to 4

endmodule