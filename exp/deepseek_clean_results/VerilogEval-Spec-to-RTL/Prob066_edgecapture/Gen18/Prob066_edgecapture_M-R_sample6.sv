module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;    // Registered previous input values
    wire [31:0] falling_edge; // Combinational falling edge detection

    // Detect falling edges (1->0 transitions)
    assign falling_edge = prev_in & ~in;

    // Sticky output registers
    reg [31:0] sticky_out;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            sticky_out <= 32'b0;
        end else begin
            // Store current input for next cycle comparison
            prev_in <= in;
            
            // Update sticky outputs - set on edge detection, stays set until reset
            sticky_out <= sticky_out | falling_edge;
        end
    end

    assign out = sticky_out;

endmodule