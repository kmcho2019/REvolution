module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0; // Reset all bits to 0 when reset is high
        end else begin
            q <= d; // Otherwise, load the input into the flip-flops
        end
    end

endmodule