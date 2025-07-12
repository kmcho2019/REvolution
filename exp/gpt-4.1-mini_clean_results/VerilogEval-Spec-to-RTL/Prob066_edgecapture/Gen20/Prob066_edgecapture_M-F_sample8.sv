module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] delayed_in;
    reg [31:0] falling_edge_reg;

    always @(posedge clk) begin
        if (reset) begin
            delayed_in      <= 32'b0;
            falling_edge_reg <= 32'b0;
            out             <= 32'b0;
        end else begin
            delayed_in      <= in;
            falling_edge_reg <= delayed_in & ~in;  // registered falling edge detection
            out             <= out | falling_edge_reg;
        end
    end

endmodule