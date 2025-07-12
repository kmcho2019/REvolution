module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding: OFF=2'b01, ON=2'b10
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            OFF:  next_state = j ? ON  : OFF;
            ON:   next_state = k ? OFF : ON;
            default: next_state = OFF; // Default safe state
        endcase
    end

    // State update (sequential) with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output driven by ON state bit
    assign out = (state == ON);

endmodule