module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational logic for edge detection
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            // Update previous input register
            prev_in <= in;
            
            // Update output register (accumulate falling edges)
            out <= out | falling_edge;
        end
    end

endmodule