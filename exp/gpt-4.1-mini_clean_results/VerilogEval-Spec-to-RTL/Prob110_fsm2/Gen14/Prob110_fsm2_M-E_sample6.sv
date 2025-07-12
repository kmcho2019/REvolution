module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // One-hot encoded states
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Moore output logic: output registered
    always @(posedge clk) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (state == ON);
    end

endmodule