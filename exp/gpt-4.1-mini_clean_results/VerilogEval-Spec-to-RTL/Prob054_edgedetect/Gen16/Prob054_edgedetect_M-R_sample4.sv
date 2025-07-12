module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Register previous input on clock
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection: previous 0 and current 1
    assign edge_detect = (~prev_in) & in;

    // Register the edge detection result for output
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule