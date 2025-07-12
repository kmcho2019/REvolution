module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0, A = 1'b1;
    reg state, next_state;

    // Combinational next state logic using ternary operators
    always @(*) begin
        next_state = (state == B) ? ((in == 1'b0) ? A : B)
                                  : ((in == 1'b0) ? B : A);
    end

    // Sequential logic for state and output with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output for B state
        end else begin
            state <= next_state;
            // output depends only on current state (Moore)
            out <= (next_state == B) ? 1'b1 : 1'b0;
        end
    end

endmodule