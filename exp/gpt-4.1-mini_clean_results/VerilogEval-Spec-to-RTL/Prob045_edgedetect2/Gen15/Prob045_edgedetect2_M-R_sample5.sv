module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    reg [7:0] prev_in;

    // Update previous input register at every positive clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // anyedge is asserted if input changed compared to previous cycle (delayed input)
    assign anyedge = in ^ prev_in;
endmodule