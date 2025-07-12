module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;

    // Output is combinational - shows current falling edges
    assign out = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end
        else begin
            prev_in <= in;
        end
    end

endmodule