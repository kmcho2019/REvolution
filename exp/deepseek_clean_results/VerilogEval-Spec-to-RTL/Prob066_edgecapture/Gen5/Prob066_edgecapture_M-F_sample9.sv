module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_ff;

    always @(posedge clk) begin
        if (reset) begin
            in_ff <= 32'b0;
            out <= 32'b0;
        end else begin
            in_ff <= in;
            // Set output bits when we detect a falling edge (1->0 transition)
            // and maintain them until reset
            out <= out | (in_ff & ~in);
        end
    end

endmodule