module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;  // Current state
    wire next_state;  // Next state (combinational)
    
    // Combinational next state logic
    assign next_state = (state == ON) ? ~k : j;
    
    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end
    
    // Output assignment
    assign out = state;

endmodule