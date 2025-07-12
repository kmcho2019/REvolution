module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;    // Stores input from previous cycle

    // Output is purely combinatorial edge detection
    assign out = reset ? 32'b0 : (prev_in & ~in);

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end
        else begin
            prev_in <= in;
        end
    end

endmodule