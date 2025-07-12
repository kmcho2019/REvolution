module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;  // Stores input from previous cycle
    reg [31:0] capture;

    // Combinational falling edge detection
    wire [31:0] falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            capture <= 32'b0;
        end
        else begin
            prev_in <= in;  // Store current input for next cycle
            capture <= capture | falling_edge;  // Set and hold detected edges
        end
    end

    assign out = capture;

endmodule