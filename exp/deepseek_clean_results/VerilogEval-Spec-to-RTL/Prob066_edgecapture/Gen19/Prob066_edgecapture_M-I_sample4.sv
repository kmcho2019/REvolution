module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_prev;   // Stores input from previous cycle
    reg [31:0] sticky;    // Sticky output bits (set on falling edges, cleared by reset)

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset clears all registers
            in_prev <= 32'b0;
            sticky <= 32'b0;
        end else begin
            // Store current input for next cycle's comparison
            in_prev <= in;
            
            // Set sticky bits when we detect falling edges (1->0 transitions)
            // Maintain previously set sticky bits until reset
            sticky <= sticky | (in_prev & ~in);
        end
    end

    // Output is the sticky register
    assign out = sticky;

endmodule