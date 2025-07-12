module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev1;    // Input from cycle N-1
    reg [31:0] prev2;    // Input from cycle N-2
    reg [31:0] captured; // Sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev1 <= 32'b0;
            prev2 <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Pipeline the input values
            prev2 <= prev1;
            prev1 <= in;
            
            // Detect falling edges between N-2 and N-1 cycles
            // and combine with existing captures
            captured <= captured | (prev2 & ~prev1);
        end
    end

    assign out = captured;

endmodule