module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;  // Reset state to B
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Moore output logic (based on current state)
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1;
        endcase
    end

endmodule