module TopModule (
    input clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Sequential logic: store the previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational logic: detect edges by XORing current and previous input
    assign anyedge = in ^ prev_in;

endmodule