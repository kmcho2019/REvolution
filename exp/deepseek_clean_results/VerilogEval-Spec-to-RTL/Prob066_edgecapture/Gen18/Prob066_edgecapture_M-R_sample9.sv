module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;      // stores previous input
    reg [31:0] capture_reg;  // permanent capture until reset

    // Continuous assignment for output
    assign out = capture_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            capture_reg <= 32'b0;
        end else begin
            // Update capture register - once set, stays set until reset
            capture_reg <= capture_reg | (prev_in & ~in);
            
            // Store current input for next cycle comparison
            prev_in <= in;
        end
    end

endmodule