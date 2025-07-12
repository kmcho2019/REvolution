module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] prev_prev_in;

    always @(posedge clk) begin
        pedge <= ~prev_prev_in & prev_in;  // Direct assignment to output register
        prev_prev_in <= prev_in;
        prev_in <= in;
    end

endmodule