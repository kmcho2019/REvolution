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
    
    // Next state logic
    assign next_state = (state == OFF) ? j :       // If OFF, transition on j
                       (state == ON)  ? ~k : 1'b0; // If ON, transition on ~k
    
    // State register
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end
    
    // Output logic
    assign out = state;

endmodule