module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] capture_reg;
    wire [31:0] falling_edge;

    // Combinational falling edge detection
    assign falling_edge = prev_in & ~in;

    // Output is the capture register
    assign out = capture_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            capture_reg <= 32'b0;
        end else begin
            // Update previous input
            prev_in <= in;
            
            // Update capture register - once set, stays set until reset
            capture_reg <= capture_reg | falling_edge;
        end
    end

endmodule