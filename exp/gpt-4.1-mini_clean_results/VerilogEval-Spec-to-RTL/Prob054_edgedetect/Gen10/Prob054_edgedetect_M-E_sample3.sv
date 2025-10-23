module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;      // delayed input to hold previous cycle's input
    reg [7:0] edge_detect_reg;

    // On every clock, store current input into in_d to remember previous input
    always @(posedge clk) begin
        in_d <= in;
    end

    // Detect positive edge combinationally (0->1 transition)
    wire [7:0] edge_detect = (~in_d) & in;

    // Register the detection signal to output pedge delayed by one cycle after transition
    always @(posedge clk) begin
        edge_detect_reg <= edge_detect;
        pedge <= edge_detect_reg;
    end

endmodule