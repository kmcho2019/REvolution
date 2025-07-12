module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edges;
    wire       edges_valid;

    // Register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection: 0->1 transitions
    assign edges = (~prev_in) & in;

    // Indicate if any edge is detected
    assign edges_valid = |edges;

    // Register detected edges, output one cycle after the transition
    // Only update pedge when edges_valid to reduce unnecessary toggling
    always @(posedge clk) begin
        if (edges_valid)
            pedge <= edges;
        else
            pedge <= 8'b0;
    end

endmodule