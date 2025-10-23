module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding: one-hot style
    localparam OFF = 2'b01,
               ON  = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON : next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output logic
    always @(*) begin
        out = (state == ON);
    end

endmodule