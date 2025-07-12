module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] in_dly;

    // Pipeline the input to get delayed input signal
    always @(posedge clk) begin
        in_dly <= in;
    end

    // Combinational positive edge detection logic
    wire [7:0] pos_edge_detect = (~in_dly) & in;

    // Register the detection output for synchronous output, delayed by one cycle
    always @(posedge clk) begin
        pedge <= pos_edge_detect;
    end

endmodule