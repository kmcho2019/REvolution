module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Extract control signals
    wire direction = amount[1];  // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0]; // 0: shift by 1, 1: shift by 8

    // Determine shift amount
    wire [5:0] shift_val = shift_by_8 ? 6'd8 : 6'd1;

    // Cast q to signed for arithmetic right shift
    wire signed [63:0] signed_q = q;

    wire [63:0] shifted = direction
                         ? ($signed(signed_q) >>> shift_val)  // arithmetic right shift
                         : (q << shift_val);                   // left shift

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule