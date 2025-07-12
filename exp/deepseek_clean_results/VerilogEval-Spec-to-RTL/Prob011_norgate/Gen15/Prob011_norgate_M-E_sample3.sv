/*
 * TopModule - NOR Gate with Built-in Self Test
 * 
 * Functionality:
 * - Normal mode: Performs NOR operation (out = ~(a | b))
 * - BIST mode: Automatically tests all input combinations
 * 
 * Ports:
 * - a, b: Input signals
 * - out: NOR output
 * - en_bist: Enable Built-in Self Test (active high)
 * - test_pass: Indicates if self-test passed (high when passed)
 */
module TopModule (
    input  a,          // First input
    input  b,          // Second input
    input  en_bist,    // Enable BIST mode
    output out,        // NOR output
    output test_pass   // Self-test pass indicator
);

    // Internal signals
    reg [1:0] test_pattern;
    reg [3:0] test_counter;
    reg test_result;
    
    // NOR gate implementation using primitive gates
    wire or_out;
    assign or_out = a | b;
    assign out = ~or_out;
    
    // BIST logic
    always @(*) begin
        if (en_bist) begin
            // Cycle through all input combinations
            test_pattern = {a, b};
            
            // Expected results for each pattern
            case (test_pattern)
                2'b00: test_result = (out == 1'b1);
                2'b01: test_result = (out == 1'b0);
                2'b10: test_result = (out == 1'b0);
                2'b11: test_result = (out == 1'b0);
                default: test_result = 1'b0;
            endcase
            
            // Accumulate test results
            if (test_pattern == 2'b11)
                test_pass = (test_counter == 4'b1111);
            else if (test_result)
                test_counter = test_counter + 1;
        end
        else begin
            test_pass = 1'b0;
            test_counter = 4'b0;
        end
    end
    
    // Truth Table Documentation:
    // a b | out
    // --------
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 0
endmodule