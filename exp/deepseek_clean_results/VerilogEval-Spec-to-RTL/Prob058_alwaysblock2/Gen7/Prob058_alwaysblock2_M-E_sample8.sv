module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Ternary operator style for continuous assignment
    assign out_assign = a ? ~b : b;
    
    // LUT-style implementation using case statement
    always @(*) begin
        case ({a, b})
            2'b00: out_always_comb = 1'b0;
            2'b01: out_always_comb = 1'b1;
            2'b10: out_always_comb = 1'b1;
            2'b11: out_always_comb = 1'b0;
        endcase
    end
    
    // State machine implementation for sequential output
    reg state;
    always @(posedge clk) begin
        if (a != b) begin
            state <= ~state;
        end
        out_always_ff <= state;
    end

    initial begin
        state = 1'b0;
    end

endmodule