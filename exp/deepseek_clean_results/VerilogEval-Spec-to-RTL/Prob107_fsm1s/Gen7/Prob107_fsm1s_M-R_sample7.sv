module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg current_state;
    wire next_state;
    
    // Next state logic (combinational)
    assign next_state = (current_state == STATE_B) ? 
                       (in ? STATE_B : STATE_A) :  // Current state B
                       (in ? STATE_A : STATE_B);   // Current state A
    
    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Output logic (Moore)
    assign out = (current_state == STATE_B);
    
endmodule