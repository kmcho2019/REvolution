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
            // First update the previous input register
            prev_in <= in;
            
            // Then detect transitions using the now-stored previous value
            // Output bits stay set once triggered until reset
            out <= (out | (prev_in & ~in));
        end
    end

endmodule