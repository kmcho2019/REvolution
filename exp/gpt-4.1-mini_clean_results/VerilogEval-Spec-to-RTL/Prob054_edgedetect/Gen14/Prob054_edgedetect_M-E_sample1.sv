module TopModule (
    input            clk,
    input     [7:0]  in,
    output reg[7:0]  pedge
);

    reg [7:0] prev_in;
    reg [7:0] pedge_next;

    // Store previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Detect positive edges and register output with one cycle latency
    always @(posedge clk) begin
        pedge <= pedge_next;
    end

    // Combinational logic for edge detection (0->1 transition)
    always @(*) begin
        pedge_next = (~prev_in) & in;
    end

endmodule