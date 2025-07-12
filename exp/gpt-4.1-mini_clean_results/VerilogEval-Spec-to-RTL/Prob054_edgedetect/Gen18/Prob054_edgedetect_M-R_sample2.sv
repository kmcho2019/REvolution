module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
        // Detect positive edges: prev_in bit == 0 and current in bit == 1
        pedge <= (~prev_in) & in;
    end

endmodule