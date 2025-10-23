module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Force state 4 when 'a' is high
    end else begin
        case (q)
            3'd4: q <= 3'd5;
            3'd5: q <= 3'd6;
            3'd6: q <= 3'd0;
            default: q <= q + 3'd1; // from 0..3..increment normally
        endcase
    end
end

endmodule