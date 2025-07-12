module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;  // Current state

    // State transition logic (combinational)
    wire next_state = reset ? OFF : 
                     (state == OFF) ? (j ? ON : OFF) :
                     (state == ON)  ? (k ? OFF : ON) :
                     OFF;

    // Sequential state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment (Moore style)
    assign out = state;

endmodule