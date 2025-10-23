module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Stage 1: register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection: detect 0->1 transitions bitwise
    assign edge_detect = (~prev_in) & in;

    // Stage 2: register detected edges, output delayed by one cycle
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule