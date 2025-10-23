module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_prev_in;  // Input from two cycles ago
    reg [31:0] prev_in;       // Input from one cycle ago
    reg [31:0] edge_detect;   // Falling edge detection
    reg [31:0] state;         // Persistent state until reset

    always @(posedge clk) begin
        if (reset) begin
            prev_prev_in <= 32'b0;
            prev_in <= 32'b0;
            edge_detect <= 32'b0;
            state <= 32'b0;
            out <= 32'b0;
        end
        else begin
            // Three-stage pipeline:
            // 1. Shift input history
            prev_prev_in <= prev_in;
            prev_in <= in;
            
            // 2. Detect falling edges (compare two cycles ago with one cycle ago)
            edge_detect <= prev_prev_in & ~prev_in;
            
            // 3. Update persistent state
            state <= state | edge_detect;
            
            // Output reflects the persistent state
            out <= state;
        end
    end

endmodule