// Novel 8-bit D flip-flop module with active high asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        case ({areset, clk})
            2'b10: // Reset condition
                q_reg <= 8'b0;
            2'b01: // Clock edge condition
                q_reg <= d;
            default:
                q_reg <= q_reg;
        endcase
    end

    // Continuous assignment for output
    assign q = q_reg;

endmodule