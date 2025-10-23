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
    assign next_state = (state == OFF) ? j : ~k;
    
    // Sequential state storage with sync reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end
    
    // Output assignment
    assign out = state;

endmodule