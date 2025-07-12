module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg [1:0] state, next_state;

    // State encodings
    parameter OFF = 2'b00;
    parameter ON  = 2'b01;

    // Next state logic
    always @(*) begin
        if (state == OFF) begin
            if (j)
                next_state = ON;
            else
                next_state = OFF;
        end else begin // state == ON
            if (k)
                next_state = OFF;
            else
                next_state = ON;
        end
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output depends only on state
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0; // safe default for unused states
        endcase
    end

endmodule