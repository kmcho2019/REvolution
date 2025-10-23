module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Reset to state B
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Moore output as continuous assignment to reduce combinational logic
    assign out = (state == B);

endmodule