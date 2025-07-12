module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;  // anyedge is high for bits that changed last cycle
        prev_in <= in;            // store current input for next cycle edge detection
    end

endmodule