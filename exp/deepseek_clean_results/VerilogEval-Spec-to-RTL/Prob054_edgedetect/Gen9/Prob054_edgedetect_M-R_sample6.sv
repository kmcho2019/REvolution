module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;

    // Sequential logic: store previous input values
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational logic: detect positive edges
    assign pedge = in & ~prev_in;

endmodule