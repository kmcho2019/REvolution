module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Registered signals with explicit initialization
    reg [31:0] captured_edges = 32'b0;
    reg [31:0] prev_input = 32'b0;

    assign out = captured_edges;

    always @(posedge clk) begin
        if (reset) begin
            captured_edges <= 32'b0;
            prev_input <= 32'b0;
        end else begin
            // Detect and capture falling edges (1->0 transitions)
            captured_edges <= captured_edges | (prev_input & ~in);
            prev_input <= in;
        end
    end

endmodule