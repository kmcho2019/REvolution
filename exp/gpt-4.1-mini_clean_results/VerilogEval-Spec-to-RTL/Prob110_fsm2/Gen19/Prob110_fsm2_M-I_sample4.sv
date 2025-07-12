module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);
    // State encoding
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state, next_state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Moore output logic
    assign out = (state == ON);

endmodule