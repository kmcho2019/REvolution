module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev1_in;  // input from 1 cycle ago
    reg [31:0] prev2_in;  // input from 2 cycles ago

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev1_in <= 32'b0;
            prev2_in <= 32'b0;
        end else begin
            // Detect falling edges with 2-cycle high requirement
            out <= out | (prev2_in & prev1_in & ~in);
            
            // Shift the input pipeline
            prev2_in <= prev1_in;
            prev1_in <= in;
        end
    end

endmodule