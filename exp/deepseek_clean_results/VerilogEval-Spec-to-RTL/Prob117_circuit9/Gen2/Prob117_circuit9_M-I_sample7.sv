module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // Initialize to 4
);

always @(posedge clk) begin
    if (a) begin
        q <= q;  // Hold current value when a=1
    end else begin
        // Count down sequence with wrap-around
        case (q)
            3'd4: q <= 3'd5;
            3'd5: q <= 3'd6;
            3'd6: q <= 3'd0;
            3'd0: q <= 3'd1;
            3'd1: q <= 3'd4;
            default: q <= 3'd4;  // Safety net
        endcase
    end
end

endmodule