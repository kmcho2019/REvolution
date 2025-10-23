module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;  // Single register for previous input

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            // Capture any new falling edges and maintain previous detections
            out <= out | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule