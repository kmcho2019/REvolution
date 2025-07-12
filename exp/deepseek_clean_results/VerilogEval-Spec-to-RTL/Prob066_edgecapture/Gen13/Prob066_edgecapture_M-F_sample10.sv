module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_prev_in;  // Input from two cycles ago
    reg [31:0] prev_in;       // Input from previous cycle
    reg [31:0] captured;      // Sticky capture register

    always @(posedge clk) begin
        if (reset) begin
            prev_prev_in <= 32'b0;
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Shift the input history pipeline
            prev_prev_in <= prev_in;
            prev_in <= in;
            
            // Detect falling edges between consecutive cycles
            // (1 in cycle N-1, 0 in cycle N)
            // and combine with existing captures
            captured <= captured | (prev_prev_in & ~prev_in);
        end
    end

    assign out = captured;

endmodule