module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev;     // Input from previous cycle
    reg [31:0] captured; // Sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            prev <= in;  // Store current input for next cycle
            
            // Detect falling edges between current and previous cycle
            // and combine with existing captures
            captured <= captured | (prev & ~in);
        end
    end

    assign out = captured;

endmodule