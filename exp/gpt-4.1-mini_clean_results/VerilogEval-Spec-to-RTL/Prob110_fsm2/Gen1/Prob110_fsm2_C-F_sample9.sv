module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            OFF: next_state = (j == 1'b1) ? ON : OFF;
            ON:  next_state = (k == 1'b1) ? OFF : ON;
            default: next_state = OFF; // safe default state
        endcase
    end

    // Output logic (Moore machine): output depends only on current state
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0; // safe default output
        endcase
    end

endmodule