module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] delayed_in;

    always @(posedge clk) begin
        if (reset) begin
            delayed_in <= 32'b0;
            out <= 32'b0;
        end else begin
            delayed_in <= in;
            out <= out | (delayed_in & ~in);
        end
    end

endmodule