module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;  // Store current input for next cycle comparison
        
        if (reset) begin
            out <= 32'b0;
        end
        else begin
            // Set output bits when 1->0 transition is detected
            out <= out | (prev_in & ~in);
        end
    end

endmodule