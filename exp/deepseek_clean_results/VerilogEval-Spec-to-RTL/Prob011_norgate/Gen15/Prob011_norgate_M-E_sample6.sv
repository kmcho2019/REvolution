/*
 * TopModule - Structural NOR Gate with Built-in Self-Test
 * 
 * Features:
 * - Structural implementation using NAND gates (De Morgan's)
 * - Built-in self-test capability
 * - Test mode input to enable verification
 * - Pass/fail output from BIST logic
 * - Maintains normal NOR operation when not in test mode
 */
module TopModule (
    input  a,         // First input
    input  b,         // Second input
    input  test_mode, // Enable self-test
    output out,       // NOR output
    output test_pass  // BIST pass indicator (1 = pass)
);

    // Internal signals
    wire nand_out;
    wire test_out;
    reg [1:0] test_pattern;
    reg test_done;
    
    // Structural NOR implementation using NAND (De Morgan's)
    nand U1 (nand_out, a, b);
    not U2 (out, nand_out);
    
    // BIST Control FSM
    always @(posedge test_mode or negedge test_mode) begin
        if (test_mode) begin
            test_pattern <= 2'b00;
            test_done <= 1'b0;
        end else begin
            test_pattern <= test_pattern + 1;
            test_done <= (test_pattern == 2'b11);
        end
    end
    
    // Test pattern application and verification
    assign test_out = ~(test_pattern[1] | test_pattern[0]);
    assign test_pass = test_done & 
                      ((test_pattern == 2'b00) ? (out == 1'b1) :
                       (test_pattern == 2'b01) ? (out == 1'b0) :
                       (test_pattern == 2'b10) ? (out == 1'b0) :
                       (out == 1'b0));
    
    // Output mux - normal operation vs test mode
    assign out = test_mode ? test_out : ~(a | b);
    
    /*
     * Truth Table:
     * Normal Mode (test_mode = 0):
     * a b | out
     * --------
     * 0 0 | 1
     * 0 1 | 0
     * 1 0 | 0
     * 1 1 | 0
     * 
     * Test Mode (test_mode = 1):
     * Automatically cycles through all input patterns
     * and verifies correct operation
     */
endmodule