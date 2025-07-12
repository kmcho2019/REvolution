module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state combinational logic with blocking assignment for clarity
    always @(*) begin
        if (state == B)
            next_state = (in == 1'b0) ? A : B;
        else // state == A
            next_state = (in == 1'b0) ? B : A;
    end

    // Output is Moore type; depends only on current state, assigned continuously
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule