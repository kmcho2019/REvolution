module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] posedge_wire;

    // Detect 0->1 transition combinationally
    assign posedge_wire = (~prev_in) & in;

    always @(posedge clk) begin
        prev_in <= in;
        pedge <= posedge_wire;  // Register the detected positive edges
    end

endmodule