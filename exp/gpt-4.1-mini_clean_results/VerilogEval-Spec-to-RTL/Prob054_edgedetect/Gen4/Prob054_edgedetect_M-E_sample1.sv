module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_dly;       // delayed input register
    wire [7:0] edge_detect;

    // Edge detection: bitwise detect rising edge from in_dly to in
    assign edge_detect = (~in_dly) & in;

    always @(posedge clk) begin
        in_dly <= in;      // delay input by one cycle
        pedge <= edge_detect;  // register edge detect output
    end

endmodule