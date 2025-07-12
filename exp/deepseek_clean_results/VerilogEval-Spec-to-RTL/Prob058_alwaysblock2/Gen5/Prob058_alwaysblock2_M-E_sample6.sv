module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Ternary operator implementation
    assign out_assign = a ? ~b : b;

    // LUT-style implementation
    always @(*) begin
        case({a,b})
            2'b00: out_always_comb = 1'b0;
            2'b01: out_always_comb = 1'b1;
            2'b10: out_always_comb = 1'b1;
            2'b11: out_always_comb = 1'b0;
        endcase
    end

    // Two-stage pipelined implementation
    reg intermediate;
    always @(posedge clk) begin
        intermediate <= a ^ b;
        out_always_ff <= intermediate;
    end

endmodule