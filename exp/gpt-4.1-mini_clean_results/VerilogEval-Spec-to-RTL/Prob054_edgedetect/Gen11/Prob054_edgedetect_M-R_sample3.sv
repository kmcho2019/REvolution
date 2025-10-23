module TopModule (
    input           clk,
    input   [7:0]   in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Store previous cycle input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Detect rising edges: previous bit 0, current bit 1
    wire [7:0] pedge_comb = (~prev_in) & in;

    // Register pedge output to delay by one cycle as required
    always @(posedge clk) begin
        pedge <= pedge_comb;
    end

endmodule