module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            // Determine shift amount and direction
            // amount: 00-left1, 01-left8, 10-right1, 11-right8
            // Use signed shift amount: positive left, negative right
            integer shift_amt;
            case (amount)
                2'b00: shift_amt = 1;
                2'b01: shift_amt = 8;
                2'b10: shift_amt = -1;
                2'b11: shift_amt = -8;
                default: shift_amt = 0;
            endcase
            // Cast q to signed for arithmetic right shifts
            if (shift_amt >= 0)
                q <= q << shift_amt;
            else
                q <= $signed(q) >>> (-shift_amt);
        end
        // else hold q
    end

endmodule