module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= {q[62:0], 1'b0};                    // shift left by 1
                2'b01: q <= {q[55:0], 8'b0};                    // shift left by 8
                2'b10: q <= {msb, q[63:1]};                     // arithmetic shift right by 1
                2'b11: q <= {{8{msb}}, q[63:8]};                // arithmetic shift right by 8
                default: q <= q;                                 // hold value (should not occur)
            endcase
        end
    end

endmodule