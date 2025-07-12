module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    // Clock gating: only enable clock when shifting or loading
    wire clk_en = ena | load;

    // Shift modes decoded from amount
    // amount: 2'b00:left1, 2'b01:left8, 2'b10:right1, 2'b11:right8
    wire shift_left  = ~amount[1];
    wire shift_right = amount[1];

    wire shift_by_1  = ~amount[0];
    wire shift_by_8  = amount[0];

    // Stage 1 shift by 8 bits or no shift
    // Left shift by 8 bits
    wire [63:0] left_s1 = shift_by_8 ? {q[55:0], 8'b0} : q;
    // Arithmetic right shift by 8 bits
    wire [63:0] right_s1 = shift_by_8 ? { {8{q[63]}}, q[63:8]} : q;

    // Stage 2 shift by 1 bit or no shift
    // Left shift by 1 bit
    wire [63:0] left_s2 = shift_by_1 ? {left_s1[62:0], 1'b0} : left_s1;
    // Arithmetic right shift by 1 bit
    // Sign extension uses the MSB of right_s1 to reduce fanout
    wire right_s1_msb = right_s1[63];
    wire [63:0] right_s2 = shift_by_1 ? {right_s1_msb, right_s1[63:1]} : right_s1;

    // Final mux between the four modes using 4-to-1 mux
    wire [63:0] shifted;
    assign shifted = (amount == 2'b00) ? left_s2  : // left by 1
                     (amount == 2'b01) ? left_s1  : // left by 8
                     (amount == 2'b10) ? right_s2 : // right by 1 (arith)
                                         right_s1;   // right by 8 (arith)

    // Gated clock for flip-flops (using clock enable)
    // Since gating clocks is tool and tech dependent,
    // here just implement enable gating inside always block

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // else hold q
    end

endmodule