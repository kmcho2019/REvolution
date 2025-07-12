module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input rst_n,           // Active-low reset
    input [WIDTH-1:0] in,  // Parameterized input width
    output [WIDTH-1:0] pedge
);

    reg [WIDTH-1:0] prev_in; // Stores previous cycle's input

    // Sequential logic with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_in <= {WIDTH{1'b0}}; // Reset all bits to 0
        end else begin
            prev_in <= in;            // Store current input
        end
    end

    // Edge detection: current=1 and previous=0
    // Uses bitwise NOT and AND for efficient implementation
    assign pedge = ~prev_in & in;

endmodule