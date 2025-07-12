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

    // Combinational edge detection: 0->1 transitions
    assign edges = (~prev_in) & in;

    // Register detected edges, output one cycle after the transition
    always @(posedge clk) begin
        pedge <= edges;
    end

endmodule