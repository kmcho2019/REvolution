module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'hFFFFFFFF;  // Initialize to all ones to avoid false detections right after reset
        end else begin
            out <= out | (prev_in & ~in); // Capture any 1->0 transitions
            prev_in <= in;                // Sample input after transition detection
        end
    end

endmodule