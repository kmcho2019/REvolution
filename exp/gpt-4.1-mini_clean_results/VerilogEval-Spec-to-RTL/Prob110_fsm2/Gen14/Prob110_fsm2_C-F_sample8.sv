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

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF; // safe default
        endcase
    end

    // Output logic (Moore output: purely combinational from state)
    // Registered output to improve glitch immunity and timing
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0; // safe default
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule