module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'hFFFFFFFF;  // Initialize to all ones to catch falling edges immediately
            out <= 32'b0;
        end else begin
            out <= out | (prev_in & ~in); // latch falling edges
            prev_in <= in;
        end
    end

endmodule