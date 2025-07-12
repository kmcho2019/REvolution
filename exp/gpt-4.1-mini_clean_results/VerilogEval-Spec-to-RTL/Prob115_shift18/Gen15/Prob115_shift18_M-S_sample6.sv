module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);
    // Use signed reg to facilitate arithmetic right shift with sign extension
    reg signed [63:0] q_signed;

    always @(posedge clk) begin
        if (load) begin
            q_signed <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q_signed <= q_signed <<< 1;        // shift left by 1
                2'b01: q_signed <= q_signed <<< 8;        // shift left by 8
                2'b10: q_signed <= q_signed >>> 1;        // arithmetic shift right by 1
                2'b11: q_signed <= q_signed >>> 8;        // arithmetic shift right by 8
                default: q_signed <= q_signed;             // hold if undefined (not needed but safe)
            endcase
        end
        // else hold q_signed
    end

    // Output as unsigned value
    always @(*) q = q_signed;

endmodule