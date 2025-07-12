module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Determine shift amount signed: 
    // Left shifts: +1 or +8 (amount[1]==0)
    // Right shifts: -1 or -8 (amount[1]==1)
    wire signed [7:0] shift_val = (amount[1] == 1'b0) 
                                  ? ((amount[0] == 1'b0) ? 8'sd1 : 8'sd8)
                                  : ((amount[0] == 1'b0) ? -8'sd1 : -8'sd8);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena) begin
            if (shift_val > 0)
                q <= q << shift_val;
            else
                // Arithmetic right shift with sign extension
                q <= $signed(q) >>> (-shift_val);
        end
    end

endmodule