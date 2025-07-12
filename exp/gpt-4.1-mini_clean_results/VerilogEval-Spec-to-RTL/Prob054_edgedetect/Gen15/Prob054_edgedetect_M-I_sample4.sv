module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edges;
    wire       update_enable;

    // Register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection: 0->1 transitions
    assign edges = (~prev_in) & in;

    // Enable signal to update pedge only when edges are detected
    assign update_enable = |edges;

    // Register detected edges, update only when edges occur (reduces toggling)
    always @(posedge clk) begin
        if (update_enable)
            pedge <= edges;
        else
            pedge <= pedge; // hold value, no toggle
    end

endmodule