module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] transition;

    // Combinational logic to detect 1->0 transitions
    assign transition = ~in & prev_in;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            // Capture transitions (OR with previous captures)
            out <= out | transition;
            // Store current input for next cycle comparison
            prev_in <= in;
        end
    end

endmodule