module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= in;  // Initialize prev_in to current input to avoid false transitions
        end else begin
            out <= out | (prev_in & ~in);  // Capture 1->0 transitions
            prev_in <= in;
        end
    end

endmodule