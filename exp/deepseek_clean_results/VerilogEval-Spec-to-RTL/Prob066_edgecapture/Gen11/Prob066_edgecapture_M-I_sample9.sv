module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;  // Previous cycle's input
    reg [31:0] captured; // Sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Store current input for next cycle comparison
            prev_in <= in;
            
            // Detect falling edges (1 in prev_in, 0 in current in)
            // and combine with existing captures
            captured <= captured | (prev_in & ~in);
        end
    end

    assign out = captured;

endmodule