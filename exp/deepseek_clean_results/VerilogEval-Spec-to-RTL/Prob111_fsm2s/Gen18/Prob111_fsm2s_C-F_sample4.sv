module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                                     (k ? OFF : ON);

    // Sequential state update with sync reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = state;

endmodule