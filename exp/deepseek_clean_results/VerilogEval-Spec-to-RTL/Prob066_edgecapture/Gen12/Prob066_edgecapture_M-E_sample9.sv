module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Two-stage history registers for each bit
    reg [31:0] prev1, prev2;
    // Sticky capture flags for each bit
    reg [31:0] sticky_flags;

    always @(posedge clk) begin
        if (reset) begin
            prev1 <= 32'b0;
            prev2 <= 32'b0;
            sticky_flags <= 32'b0;
        end
        else begin
            // Shift history
            prev2 <= prev1;
            prev1 <= in;
            
            // Update sticky flags
            sticky_flags <= sticky_flags | (prev2 & ~prev1);
        end
    end

    assign out = sticky_flags;

endmodule