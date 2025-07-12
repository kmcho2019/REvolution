module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_high;

    always @(posedge clk) begin
        if (reset) begin
            prev_high <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect bits that were high and are now low (falling edge)
            out <= out | (prev_high & ~in);
            // Update prev_high to current high bits
            prev_high <= in;
        end
    end

endmodule