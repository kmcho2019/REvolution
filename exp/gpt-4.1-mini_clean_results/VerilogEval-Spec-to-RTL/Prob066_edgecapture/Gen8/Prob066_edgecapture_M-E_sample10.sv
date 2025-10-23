module TopModule (
    input              clk,
    input              reset,
    input      [31:0]  in,
    output reg [31:0]  out
);

    reg [31:0] prev_in;
    reg [31:0] capture;

    wire [31:0] falling_edge;
    assign falling_edge = prev_in & (~in);

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            capture <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_in <= in;
            capture <= capture | falling_edge;
            out <= capture | falling_edge;
        end
    end

endmodule