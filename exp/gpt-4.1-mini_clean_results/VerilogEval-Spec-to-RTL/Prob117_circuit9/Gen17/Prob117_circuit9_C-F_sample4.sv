module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

reg [2:0] next_state;

always @(*) begin
    if (a) begin
        next_state = 3'd4;
    end else begin
        // Arithmetic modulo-7 increment with wraparound at 6
        next_state = (q == 3'd6) ? 3'd0 : (q + 3'd1);
    end
end

always @(posedge clk) begin
    q <= next_state;
end

endmodule