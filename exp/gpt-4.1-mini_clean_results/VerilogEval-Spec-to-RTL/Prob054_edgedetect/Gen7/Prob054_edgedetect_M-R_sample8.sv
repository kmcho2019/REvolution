module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edges;

    // Register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Detect edges combinationally
    assign edges = (~prev_in) & in;

    // Register output pulses one cycle after edge detection
    always @(posedge clk) begin
        pedge <= edges;
    end

endmodule