module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Store previous input on clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational detection of 0->1 transitions (positive edges)
    assign edge_detect = (~prev_in) & in;

    // Register the edge detection output to delay by one cycle
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule