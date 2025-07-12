module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;     // Initialize prev_in with current input to avoid missing edges after reset
            out <= 32'b0;
        end else begin
            out <= out | (prev_in & ~in); // Latch falling edges until reset
            prev_in <= in;
        end
    end

endmodule