module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding (2 bits used, though only 2 states defined)
    localparam [1:0]
        OFF = 2'b00,
        ON  = 2'b01;

    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Output combinational logic (Moore output depends only on state)
    always @(*) begin
        case(state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

    // Sequential logic for state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule