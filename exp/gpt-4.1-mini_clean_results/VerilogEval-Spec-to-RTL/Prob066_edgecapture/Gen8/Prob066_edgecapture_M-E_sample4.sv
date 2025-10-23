module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] latched_falling;

    always @(posedge clk) begin
        if (reset) begin
            prev_in         <= 32'b0;
            latched_falling <= 32'b0;
            out             <= 32'b0;
        end else begin
            // Detect falling edges: prev_in=1 & in=0 per bit
            latched_falling <= latched_falling | (prev_in & ~in);
            prev_in         <= in;
            out             <= latched_falling;
        end
    end

endmodule