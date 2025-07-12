module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev1_in;  // Stores input from cycle N-1
    reg [31:0] prev2_in;  // Stores input from cycle N-2
    reg [31:0] capture;

    always @(posedge clk) begin
        if (reset) begin
            prev1_in <= 32'b0;
            prev2_in <= 32'b0;
            capture <= 32'b0;
        end
        else begin
            // Shift the pipeline: new input -> prev1, prev1 -> prev2
            prev2_in <= prev1_in;
            prev1_in <= in;
            
            // Detect falling edges between properly aligned consecutive samples
            // Once set, bits stay set until reset
            capture <= capture | (prev2_in & ~prev1_in);
        end
    end

    assign out = capture;

endmodule