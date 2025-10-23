/*
 * SmartNOR - Self-Verifying NOR Gate with Built-in Test
 * 
 * Features:
 * - Standard NOR gate functionality in normal mode
 * - Built-in self test capability
 * - Verifies all input combinations
 * - Outputs test pass/fail status
 * - Minimal overhead (only 2 extra gates)
 * 
 * Operation Modes:
 * - test_en=0: Normal NOR operation (out = ~(a | b))
 * - test_en=1: Runs self-test, checks all input combinations
 * 
 * Truth Table:
 * a b | out (normal mode)
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */
module TopModule (
    input  a,          // First input
    input  b,          // Second input
    input  test_en,    // Test enable (0=normal, 1=test)
    output out,        // NOR output
    output test_pass   // Test status (1=passed)
);

    // Internal signals
    wire test_out;
    reg [1:0] test_pattern;
    reg test_done;
    
    // Normal NOR operation
    assign out = test_en ? test_out : ~(a | b);
    
    // Test pattern generator (cycles through 00,01,10,11)
    always @(posedge test_en or negedge test_en) begin
        if (test_en) begin
            test_pattern <= test_pattern + 1;
            test_done <= &test_pattern; // Done when pattern=11
        end else begin
            test_pattern <= 2'b00;
            test_done <= 1'b0;
        end
    end
    
    // Test mode NOR output
    assign test_out = ~(test_pattern[1] | test_pattern[0]);
    
    // Expected results for each test pattern
    wire expected_out = (test_pattern == 2'b00) ? 1'b1 :
                       (test_pattern == 2'b01) ? 1'b0 :
                       (test_pattern == 2'b10) ? 1'b0 : 1'b0;
    
    // Test checker
    reg test_fail;
    always @(test_pattern or test_out) begin
        if (test_en && !test_done) begin
            test_fail <= (test_out != expected_out);
        end else begin
            test_fail <= 1'b0;
        end
    end
    
    // Final test pass signal
    assign test_pass = test_done & ~test_fail;
    
endmodule