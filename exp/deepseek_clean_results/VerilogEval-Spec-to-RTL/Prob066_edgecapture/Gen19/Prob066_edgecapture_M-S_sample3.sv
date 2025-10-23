module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] capture_reg;
    reg [31:0] prev_in;

    assign out = capture_reg;

    always @(posedge clk) begin
        if (reset) begin
            capture_reg <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            capture_reg <= capture_reg | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule