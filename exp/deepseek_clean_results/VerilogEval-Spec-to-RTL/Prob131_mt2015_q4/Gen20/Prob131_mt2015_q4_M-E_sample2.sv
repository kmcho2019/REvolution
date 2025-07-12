module TimeMultiplexedModule(
    input clk,        // Added clock for time-multiplexing
    input x,
    input y,
    output reg z
);
    reg phase;        // 0: ModuleA phase, 1: ModuleB phase
    reg a_out, b_out;
    wire core_out;
    
    // Shared computation core
    assign core_out = phase ? ~(x ^ y) : (x & ~y);
    
    always @(posedge clk) begin
        phase <= ~phase;  // Toggle phase every cycle
        
        if (~phase) begin
            // ModuleA phase
            a_out <= core_out;
        end else begin
            // ModuleB phase
            b_out <= core_out;
            // Combine results in B phase
            z <= (a_out | b_out) ^ (a_out & b_out);
        end
    end
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Generate internal clock (for demonstration)
    reg clk = 0;
    always #5 clk = ~clk;
    
    TimeMultiplexedModule tm(
        .clk(clk),
        .x(x),
        .y(y),
        .z(z)
    );
endmodule