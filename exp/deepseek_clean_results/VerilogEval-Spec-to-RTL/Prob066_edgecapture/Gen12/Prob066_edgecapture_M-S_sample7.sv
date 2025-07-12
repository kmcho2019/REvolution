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
            prev_in <= 32'b0;
        end
        else begin
            prev_in <= in;
            // Set output bits when we detect a falling edge (1->0)
            // and keep them set until reset
            out <= out | (prev_in & ~in);
        end
    end

endmodule