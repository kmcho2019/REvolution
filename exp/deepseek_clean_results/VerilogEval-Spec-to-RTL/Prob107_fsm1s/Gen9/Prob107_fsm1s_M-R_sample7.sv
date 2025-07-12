module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State parameters
    localparam B = 1'b0;
    localparam A = 1'b1;
    
    // State storage
    reg current_state;
    
    // Next state logic (combinational)
    wire next_state = (current_state == B) ? (in ? B : A) : (in ? A : B);
    
    // State transition (synchronous)
    always @(posedge clk) begin
        current_state <= reset ? B : next_state;
    end
    
    // Output logic (combinational)
    assign out = (current_state == B);  // Explicit version of ~current_state

endmodule