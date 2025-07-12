module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    // Detect positive edge bits combinationally
    wire [7:0] pos_edge_detect = (~prev_in) & in;

    // Enable update only when any positive edge occurs
    wire any_edge = |pos_edge_detect;

    always @(posedge clk) begin
        prev_in <= in;
        if (any_edge)
            pedge <= pos_edge_detect;
        else
            pedge <= 8'b0;  // Clear pedge if no edge detected (pulse behavior)
    end

endmodule