module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions with localparam for encapsulation
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg current_state;
    wire next_state;
    
    // Combinational next-state logic with case statement
    assign next_state = (current_state == STATE_B) ? 
                       (in ? STATE_B : STATE_A) :  // Current state B
                       (in ? STATE_A : STATE_B);   // Current state A
    
    // Single always block for state register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Direct output assignment for clarity
    assign out = (current_state == STATE_B);
    
endmodule