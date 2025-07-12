module TopModule (
    input         clk,
    input         reset,
    input  [31:0] current_input,
    output [31:0] detected_falls
);

    reg [31:0] previous_input;  // Stores input from previous cycle
    reg [31:0] fall_flags;      // Sticky flags for detected falling edges

    always @(posedge clk) begin
        if (reset) begin
            // Clear all registers on synchronous reset
            previous_input <= 32'b0;
            fall_flags <= 32'b0;
        end else begin
            // Store current input for next cycle's comparison
            previous_input <= current_input;
            
            // Detect falling edges (1->0 transitions) and set sticky flags
            // Each bit maintains its state until next reset
            fall_flags <= fall_flags | (previous_input & ~current_input);
        end
    end

    // Output is the accumulated falling edge detection flags
    assign detected_falls = fall_flags;

endmodule