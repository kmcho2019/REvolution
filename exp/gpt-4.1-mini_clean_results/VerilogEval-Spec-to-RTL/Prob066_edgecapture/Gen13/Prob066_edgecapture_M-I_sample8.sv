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
            prev_in <= in;       // Initialize prev_in to current input on reset
            captured <= 32'b0;
        end else begin
            captured <= captured | (prev_in & ~in);
            prev_in <= in;
        end
    end

    assign out = captured;

endmodule