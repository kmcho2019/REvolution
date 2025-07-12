module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges by comparing prev_in and current in inside sequential logic
            out <= out | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule