module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;

    // Update previous input register on clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Detect positive edges combinationally and register output
    always @(posedge clk) begin
        pedge <= (~prev_in) & in;
    end

endmodule