module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 3'd4; // Hold q=4 when a=1
    end else begin
        // Next state based on current q following the modulo-7 cycle
        case (q)
            3'd4: next_q = 3'd5;
            3'd5: next_q = 3'd6;
            3'd6: next_q = 3'd0;
            3'd0: next_q = 3'd1;
            3'd1: next_q = 3'd2;
            3'd2: next_q = 3'd3;
            3'd3: next_q = 3'd4;
            default: next_q = 3'd4; // Recover to 4 if q unknown or invalid
        endcase
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule