module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    // State feedback wire
    wire state;
    reg state_reg;

    // Next state logic (combinational)
    assign state = reset ? STATE_B : 
                  (state_reg ? in : ~in);

    // State register (D-flip-flop)
    always @(posedge clk) begin
        state_reg <= state;
    end

    // Output logic (combinational)
    assign out = (state_reg == STATE_B);

endmodule