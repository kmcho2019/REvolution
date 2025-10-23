module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment using ternary operator
    assign out_assign = a ? ~b : b;

    // Combinational always block using LUT
    always @(*) begin
        case ({a, b})
            2'b00: out_always_comb = 1'b0;
            2'b01: out_always_comb = 1'b1;
            2'b10: out_always_comb = 1'b1;
            2'b11: out_always_comb = 1'b0;
        endcase
    end

    // Sequential always block using state machine
    reg [1:0] state;
    always @(posedge clk) begin
        case (state)
            2'b00: out_always_ff <= (a ^ b);
            2'b01: out_always_ff <= (a ^ b);
            2'b10: out_always_ff <= (a ^ b);
            2'b11: out_always_ff <= (a ^ b);
        endcase
        state <= {a, b};
    end

endmodule