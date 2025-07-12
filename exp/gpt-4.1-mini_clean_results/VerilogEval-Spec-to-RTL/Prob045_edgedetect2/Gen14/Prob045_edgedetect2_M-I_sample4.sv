module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // On clock edge, store the current input vector as previous input for next cycle comparison
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Detect edges by XORing current and previous input bits
    assign anyedge = prev_in ^ in;

endmodule