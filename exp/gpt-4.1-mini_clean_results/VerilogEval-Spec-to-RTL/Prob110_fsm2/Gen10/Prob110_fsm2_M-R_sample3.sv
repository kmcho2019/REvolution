module TopModule (
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

    // Next state logic combinational using if-else
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

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic combinational based on current state (Moore output)
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0; // Defensive default
        endcase
    end

endmodule