module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // On every clock, capture current input to detect edges in next cycle
    always @(posedge clk) begin
        prev_in <= in;
    end

    // anyedge is high if current input differs from previous input (edge detected last cycle)
    assign anyedge = in ^ prev_in;

endmodule