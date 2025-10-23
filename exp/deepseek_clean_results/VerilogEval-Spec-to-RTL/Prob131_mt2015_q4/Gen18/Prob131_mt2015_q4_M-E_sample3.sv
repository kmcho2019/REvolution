module TimeMultiplexedTop(
    input clk,
    input x,
    input y,
    output reg z
);
    // Phase control (1-bit counter)
    reg phase;
    always @(posedge clk) phase <= ~phase;
    
    // Shared computation units
    wire a_out = x & ~y;  // ModuleA function
    wire b_out = ~(x ^ y); // ModuleB function
    
    // Result storage
    reg stored_or, stored_and;
    
    // Phase 1: Compute and store ModuleA results
    always @(posedge clk) if (phase) begin
        stored_or <= a_out | b_out;  // First pair
        stored_and <= a_out & b_out; // Second pair
    end
    
    // Phase 2: Compute final output
    always @(posedge clk) if (~phase) begin
        z <= stored_or ^ stored_and;
    end
endmodule