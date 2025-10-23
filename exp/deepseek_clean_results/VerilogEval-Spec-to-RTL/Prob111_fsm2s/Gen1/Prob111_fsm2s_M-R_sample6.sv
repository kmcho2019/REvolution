module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Define states
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State and next state wires
    wire next_state;
    reg state;

    // Next state logic (combinational)
    assign next_state = reset ? OFF : 
                       (state == OFF) ? (j ? ON : OFF) :
                       (k ? OFF : ON);

    // State register (sequential)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == ON);

endmodule