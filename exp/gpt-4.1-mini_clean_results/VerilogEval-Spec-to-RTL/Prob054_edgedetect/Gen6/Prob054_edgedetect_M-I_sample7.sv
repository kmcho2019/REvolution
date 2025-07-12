module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in; // Store previous input
    end

    // Combinational detection of 0->1 transition relative to previous input
    assign pedge = (~prev_in) & in;

endmodule