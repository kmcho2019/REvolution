module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;  // Store input for next-cycle edge detection
    end

    // Detect 0->1 edges by comparing current input with previous input (combinational)
    assign pedge = (~prev_in) & in;

endmodule