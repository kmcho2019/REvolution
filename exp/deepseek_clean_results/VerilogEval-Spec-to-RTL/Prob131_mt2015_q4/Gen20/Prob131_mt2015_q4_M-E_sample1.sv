module TemporalSharedCore(
    input clk,
    input x,
    input y,
    output reg z
);
    reg mode;  // 0: compute A, 1: compute B
    reg a_result, b_result;
    reg result_valid;
    
    // Computation core (time-shared)
    always @(posedge clk) begin
        mode <= ~mode;  // Toggle mode each cycle
        
        if (!mode) begin
            // Compute Module A function: (x^y) & x
            a_result <= (x ^ y) & x;
        end
        else begin
            // Compute Module B function: ~(x ^ y)
            b_result <= ~(x ^ y);
        end
        
        // Result becomes valid after both computations complete
        result_valid <= mode;
    end
    
    // Output combination (triggered when results are valid)
    always @(posedge clk) begin
        if (result_valid) begin
            z <= (a_result | b_result) ^ (a_result & b_result);
        end
    end
endmodule

module TopModule(
    input clk,
    input x,
    input y,
    output z
);
    // Instantiate the temporal shared core
    TemporalSharedCore core(
        .clk(clk),
        .x(x),
        .y(y),
        .z(z)
    );
    
    // Note: The output will be valid every other clock cycle
    // due to the temporal nature of the computation
endmodule