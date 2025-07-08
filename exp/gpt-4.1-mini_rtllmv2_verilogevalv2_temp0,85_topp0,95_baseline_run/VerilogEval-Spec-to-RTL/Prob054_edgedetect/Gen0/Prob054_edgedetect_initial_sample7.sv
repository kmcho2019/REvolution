module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge <= (~prev_in) & in;  // Detect 0 to 1 transition from prev_in to in
        prev_in <= in;
    end

endmodule