module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    localparam OFF = 1'b0, ON = 1'b1;

    reg state;

    wire next_state_off, next_state_on;

    // Next state logic using continuous assign
    assign next_state_off = (state == OFF) && (j == 1'b1);
    assign next_state_on  = (state == ON)  && (k == 1'b0);

    wire next_state = (next_state_off) ? ON :
                      (next_state_on)  ? ON :
                      (state == ON && k == 1'b1) ? OFF :
                      OFF; // covers OFF with j=0

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output depends only on current state (Moore)
    assign out = (state == ON);

endmodule