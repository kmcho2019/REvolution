module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_d; // delayed version of input to detect transitions

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_d <= 32'b0;
        end else begin
            in_d <= in;
            // For each bit, set out bit if transition 1->0 detected or keep previous out bit
            out <= out | (in_d & ~in);
        end
    end

endmodule