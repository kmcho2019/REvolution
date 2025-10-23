module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_prev;
    reg [31:0] edge_capture;

    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 32'b0;
            edge_capture <= 32'b0;
        end else begin
            in_prev <= in;
            edge_capture <= edge_capture | (in_prev & ~in);
        end
    end

    assign out = edge_capture;

endmodule