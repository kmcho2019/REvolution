module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev1_in, prev2_in;
    reg [31:0] captured;

    always @(posedge clk) begin
        if (reset) begin
            prev1_in <= 32'b0;
            prev2_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Shift the pipeline
            prev2_in <= prev1_in;
            prev1_in <= in;
            
            // Detect falling edges (1->0 transitions between prev2 and prev1)
            // and accumulate in captured register
            captured <= captured | (prev2_in & ~prev1_in);
        end
    end

    assign out = captured;

endmodule