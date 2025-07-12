module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state;
    wire [1:0] next_state_0, next_state_1;
    wire [1:0] next_state;

    // Parallel next state computation for both input cases
    assign next_state_0 = (state == 2'b00) ? 2'b00 :  // A->A
                         (state == 2'b01) ? 2'b10 :  // B->C
                         (state == 2'b10) ? 2'b00 :  // C->A
                                           2'b10;   // D->C

    assign next_state_1 = (state == 2'b00) ? 2'b01 :  // A->B
                         (state == 2'b01) ? 2'b01 :  // B->B
                         (state == 2'b10) ? 2'b11 :  // C->D
                                           2'b01;   // D->B

    // Select actual next state based on input
    assign next_state = in ? next_state_1 : next_state_0;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;
        else
            state <= next_state;
    end

    // Output is high only in state D (11)
    assign out = (state == 2'b11);

endmodule