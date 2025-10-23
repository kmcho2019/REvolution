module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] delayed_in;  // Holds input delayed by one clock cycle

    always @(posedge clk) begin
        if (reset) begin
            delayed_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Update delayed input
            delayed_in <= in;
            // Detect bits that transitioned from 1 to 0
            out <= out | (delayed_in & ~in);
        end
    end

endmodule