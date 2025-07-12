module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding as individual wires for clarity
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State transition and output logic combined
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output assigned continuously based on current state (Moore)
    assign out = (state == B);

endmodule