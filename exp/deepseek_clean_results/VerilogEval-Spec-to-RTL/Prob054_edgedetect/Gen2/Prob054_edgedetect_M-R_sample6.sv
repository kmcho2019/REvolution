module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Store previous input value
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Continuous assignment for edge detection
    assign edge_detect = in & ~prev_in;

    // Register the output
    reg [7:0] pedge_reg;
    always @(posedge clk) begin
        pedge_reg <= edge_detect;
    end

    assign pedge = pedge_reg;

endmodule