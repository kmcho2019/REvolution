module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [3:0] q_plus_1 = q + 1;    // 4-bit sum to check overflow beyond 7
reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 3'd4;
    end else begin
        // Increment q modulo 7
        // If q+1 == 7 (3'b111), wrap to 0; else q+1
        if (q_plus_1 == 4'd7)
            next_q = 3'd0;
        else if (q <= 3'd6)
            next_q = q + 1;
        else
            next_q = 3'd4; // recover invalid states
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule