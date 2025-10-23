module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_dly;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        in_dly     <= in;
        edge_detect <= in ^ in_dly;  // Detect edges on current cycle
        anyedge    <= edge_detect;  // Output edges from previous cycle, delayed by 1 cycle
    end

endmodule