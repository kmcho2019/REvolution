module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_prev;     // Previous input value
    reg [31:0] sticky_out;  // Sticky output register

    // Combinational falling edge detection
    wire [31:0] falling_edge = in_prev & ~in;

    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 32'b0;
            sticky_out <= 32'b0;
        end else begin
            // Store current input for next cycle comparison
            in_prev <= in;
            
            // Update sticky outputs (set on edge, cleared only by reset)
            sticky_out <= sticky_out | falling_edge;
        end
    end

    assign out = sticky_out;

endmodule