module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [3:0] q_extended;  // Extended to 4 bits for safe modulo arithmetic
reg [3:0] next_q_extended;

always @(*) begin
    if (a) begin
        next_q_extended = 4'd4; // Hold or reset to state 4 when a=1
    end else begin
        // If q in 0..6, increment modulo 7; else recover to 4
        if (q <= 3'd6) begin
            next_q_extended = (q + 4'd1) % 7;
        end else begin
            next_q_extended = 4'd4; // recover invalid states
        end
    end
end

always @(posedge clk) begin
    q <= next_q_extended[2:0];
end

endmodule