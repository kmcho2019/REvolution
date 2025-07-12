module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            prev_in <= in;
            // Set captured bits when we see 1→0 transitions
            // OR keep previously captured bits
            captured <= captured | (prev_in & ~in);
        end
    end

    assign out = captured;

endmodule