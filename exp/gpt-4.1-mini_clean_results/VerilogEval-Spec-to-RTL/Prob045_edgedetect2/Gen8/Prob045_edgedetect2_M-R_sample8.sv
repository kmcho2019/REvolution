module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    // Register the previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Detect edges by XORing current input with previous input; output registered to be one cycle delayed
    always @(posedge clk) begin
        anyedge <= in ^ prev_in;
    end

endmodule