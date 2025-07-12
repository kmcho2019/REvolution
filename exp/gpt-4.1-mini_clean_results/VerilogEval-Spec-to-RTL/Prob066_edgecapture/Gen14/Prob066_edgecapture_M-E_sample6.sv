module TopModule (
    input wire        clk,
    input wire        reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_d1;  // input delayed by 1 clock cycle
    reg [31:0] in_d2;  // input delayed by 2 clock cycles
    wire [31:0] fall_edge;

    // Detect falling edges between in_d2 (previous) and in_d1 (current)
    assign fall_edge = in_d2 & ~in_d1;

    always @(posedge clk) begin
        if (reset) begin
            in_d1 <= 32'b0;
            in_d2 <= 32'b0;
            out <= 32'b0;
        end else begin
            in_d1 <= in;
            in_d2 <= in_d1;
            out <= out | fall_edge;
        end
    end

endmodule