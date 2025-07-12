module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] transition;

    // Detect 1->0 transitions
    assign transition = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            // Set output bits when transition occurs and hold until reset
            out <= out | transition;
            prev_in <= in;
        end
    end

endmodule