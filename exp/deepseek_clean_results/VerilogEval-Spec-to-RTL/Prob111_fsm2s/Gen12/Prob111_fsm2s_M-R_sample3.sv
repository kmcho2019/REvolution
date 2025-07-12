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

    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = reset ? OFF : 
                       (state == OFF) ? (j ? ON : OFF) :
                       (k ? OFF : ON);

    // Sequential state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment
    assign out = state;

endmodule