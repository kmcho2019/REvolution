module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;   // Initialize to current input to prevent false falling edges
            out <= 32'b0;
        end else begin
            out <= out | (prev_in & ~in);  // latch falling edges
            prev_in <= in;
        end
    end

endmodule