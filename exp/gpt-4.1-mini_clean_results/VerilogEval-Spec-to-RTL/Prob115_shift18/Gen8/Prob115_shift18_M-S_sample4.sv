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
            case (amount)
                2'b00: q <= {q[62:0], 1'b0};                      // shift left 1
                2'b01: q <= {q[55:0], 8'b0};                      // shift left 8
                2'b10: q <= {q[63], q[63:1]};                     // shift right 1 (arith)
                2'b11: q <= {{8{q[63]}}, q[63:8]};                // shift right 8 (arith)
                default: q <= q;
            endcase
        end
        // else hold q
    end

endmodule