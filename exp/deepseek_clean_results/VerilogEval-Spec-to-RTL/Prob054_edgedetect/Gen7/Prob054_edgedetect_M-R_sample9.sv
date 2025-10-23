module TopModule (
    input clk,            // Clock input
    input [7:0] in,       // 8-bit input vector
    output [7:0] pedge    // Positive edge detection outputs
);

    reg [7:0] prev_in;    // Stores input values from previous cycle

    // Sequential block: store previous input values
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational block: detect 0->1 transitions
    assign pedge = in & ~prev_in;

endmodule