module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] captured;
    reg [31:0] in_ff;

    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            captured <= 32'b0;
            in_ff <= 32'b0;
        end
        else begin
            in_ff <= in;
            captured <= captured | (in_ff & ~in);
        end
    end

endmodule