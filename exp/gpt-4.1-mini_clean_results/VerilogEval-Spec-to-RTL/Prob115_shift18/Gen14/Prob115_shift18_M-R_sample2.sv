module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    // Compute signed shift amount: positive for left, negative for right arithmetic
    // amount encoding:
    // 2'b00: left shift 1  => +1
    // 2'b01: left shift 8  => +8
    // 2'b10: right shift 1 => -1
    // 2'b11: right shift 8 => -8
    wire signed [6:0] shift_signed;
    assign shift_signed = (amount[1] == 1'b0) ? // left shift
                          ((amount[0] == 1'b0) ? 7'd1 : 7'd8) :
                          ((amount[0] == 1'b0) ? -7'd1 : -7'd8);

    // Compute next value combinationally
    reg [63:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena) begin
            if (shift_signed > 0) begin
                // Logical left shift by shift_signed bits
                next_q = q << shift_signed;
            end else begin
                // Arithmetic right shift by abs(shift_signed)
                // Replicate sign bit accordingly
                integer abs_shift;
                abs_shift = -shift_signed;
                next_q = { {64{q[63]}} } >> abs_shift; // shift with sign extension
                next_q = (q >>> abs_shift); // alternative: arithmetic shift right in Verilog
            end
        end else begin
            next_q = q; // hold
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule