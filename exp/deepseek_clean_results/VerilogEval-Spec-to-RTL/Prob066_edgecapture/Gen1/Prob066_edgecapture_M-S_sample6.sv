module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] reg_in;

    always @(posedge clk) begin
        if (reset) begin
            reg_in <= 32'b0;
        end else begin
            // For each bit: if previously 1 and now 0, set to 1
            // Otherwise maintain current state
            reg_in <= (reg_in | (reg_in & ~in));
        end
    end

    assign out = reg_in;

endmodule