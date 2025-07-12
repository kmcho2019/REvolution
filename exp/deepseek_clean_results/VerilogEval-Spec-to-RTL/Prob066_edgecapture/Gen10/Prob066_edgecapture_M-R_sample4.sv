module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;  // input from previous cycle
    wire [31:0] falling_edge;  // combinational falling edge detection

    // Combinational logic for falling edge detection
    assign falling_edge = prev_in & ~in;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            // Latch any new falling edges (OR with previous outputs)
            out <= out | falling_edge;
            
            // Store current input for next cycle
            prev_in <= in;
        end
    end

endmodule