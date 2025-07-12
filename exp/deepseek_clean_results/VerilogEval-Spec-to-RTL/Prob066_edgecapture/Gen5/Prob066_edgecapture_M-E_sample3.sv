module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev1, prev2;
    reg [31:0] capture;

    always @(posedge clk) begin
        if (reset) begin
            prev1 <= 32'b0;
            prev2 <= 32'b0;
            capture <= 32'b0;
        end
        else begin
            // Shift pipeline
            prev2 <= prev1;
            prev1 <= in;
            
            // Update capture registers
            capture <= capture | (prev2 & prev1 & ~in);
        end
    end

    assign out = capture;

endmodule