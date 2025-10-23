module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        if (q != 3'd4)
            q <= 3'd4;
    end else begin
        // Advance q in the 7-state sequence modulo 7: states 4,5,6,0,1,2,3
        // Calculate next q as (q+1) mod 7 mapped to desired states
        // Implement modulo-7 counting with mapping:
        // if q<6 then q+1 else 0 (for 3 bits, wrap 0-6)
        // but states are 0-3 and 4-6 in sequence
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule