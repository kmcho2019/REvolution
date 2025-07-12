module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Use a signed 64-bit intermediate to perform arithmetic right shifts naturally
    reg signed [63:0] q_signed;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q_signed = q;  // cast to signed
            case (amount)
                2'b00: q <= q << 1;
                2'b01: q <= q << 8;
                2'b10: q <= $signed(q_signed) >>> 1;
                2'b11: q <= $signed(q_signed) >>> 8;
                default: q <= q;
            endcase
        end
    end

endmodule