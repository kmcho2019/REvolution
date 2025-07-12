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

    // Next state logic (combined)
    always @(*) begin
        next_state = (state == B) ? ((in == 1'b0) ? A : B)
                                  : ((in == 1'b0) ? B : A);
    end

    // Output driven by state directly (Moore output)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule