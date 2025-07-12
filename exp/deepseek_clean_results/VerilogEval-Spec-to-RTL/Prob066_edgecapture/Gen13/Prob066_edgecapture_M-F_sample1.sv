module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;  // Stores previous input values

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            // Update output: maintain all historical detections OR new falling edges
            out <= out | (prev_in & ~in);
            
            // Update previous input values for next cycle
            prev_in <= in;
        end
    end

endmodule