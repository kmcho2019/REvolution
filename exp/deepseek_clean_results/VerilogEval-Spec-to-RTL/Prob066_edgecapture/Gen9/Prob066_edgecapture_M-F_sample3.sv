module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev1_in;  // Stores input from 1 cycle ago
    reg [31:0] prev2_in;  // Stores input from 2 cycles ago
    reg [31:0] capture;   // Sticky capture register
    wire [31:0] falling_edge;

    // Falling edge detection between two properly registered values
    assign falling_edge = prev2_in & ~prev1_in;

    always @(posedge clk) begin
        if (reset) begin
            prev1_in <= 32'b0;
            prev2_in <= 32'b0;
            capture <= 32'b0;
        end
        else begin
            // Shift the pipeline
            prev2_in <= prev1_in;
            prev1_in <= in;
            
            // Update sticky capture
            capture <= capture | falling_edge;
        end
    end

    assign out = capture;

endmodule