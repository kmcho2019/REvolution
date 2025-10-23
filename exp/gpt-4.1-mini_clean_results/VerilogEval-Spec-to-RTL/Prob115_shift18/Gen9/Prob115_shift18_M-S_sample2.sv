module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Compute signed shift amount:
    // Left shift: positive shift (1 or 8)
    // Right shift: negative shift (-1 or -8)
    wire signed [6:0] shift_val = (amount[1] == 1'b0) ?   // direction = 0: left shift
                                  (amount[0] ? 7'sd8 : 7'sd1) :
                                  (amount[0] ? -7'sd8 : -7'sd1);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            // Perform shift using signed shift amount; arithmetic right shift handled by signed shift
            q <= $signed(q) <<< shift_val;
        // else hold q
    end

endmodule