/*
 * TopModule - Structural NOR Gate with BIST
 * 
 * Functionality:
 * - Normal mode: Performs NOR operation (out = ~(a | b))
 * - Test mode: Cycles through all input patterns and verifies outputs
 * 
 * Ports:
 * - a, b: Normal inputs
 * - out: NOR output
 * - test_en: Test mode enable (active high)
 * - test_pass: Goes high when all test patterns pass
 */
module TopModule (
    input  a,         // First input
    input  b,         // Second input
    input  test_en,   // Test mode enable
    output out,       // NOR output
    output test_pass  // Test passed indicator
);

    // Internal signals
    wire or_out;
    wire test_out;
    reg [1:0] test_pattern;
    reg test_done;
    reg pass_reg;

    // Structural NOR implementation
    or U1 (or_out, a, b);
    not U2 (out, or_out);

    // BIST logic - only active when test_en=1
    always @(posedge test_en or negedge test_en) begin
        if (test_en) begin
            test_pattern <= 2'b00;
            test_done <= 1'b0;
            pass_reg <= 1'b1;
        end else begin
            test_pattern <= 2'b00;
            test_done <= 1'b0;
            pass_reg <= 1'b0;
        end
    end

    always @(*) begin
        if (test_en) begin
            case (test_pattern)
                2'b00: test_out = 1'b1;
                2'b01: test_out = 1'b0;
                2'b10: test_out = 1'b0;
                2'b11: test_out = 1'b0;
                default: test_out = 1'bx;
            endcase
        end else begin
            test_out = out;
        end
    end

    assign test_pass = test_done & pass_reg;

    // Test pattern generator and checker
    always @(posedge test_en) begin
        if (test_en && !test_done) begin
            if (out !== test_out) begin
                pass_reg <= 1'b0;
            end
            test_pattern <= test_pattern + 1;
            if (test_pattern == 2'b11) begin
                test_done <= 1'b1;
            end
        end
    end
endmodule