module TopModule (
    input clk,
    input a,
    output reg q
);
    wire d;
    // Invert input combinationally
    assign d = ~a;

    // Simple DFF capturing the inverted input at posedge clk
    always @(posedge clk) begin
        q <= d;
    end
endmodule