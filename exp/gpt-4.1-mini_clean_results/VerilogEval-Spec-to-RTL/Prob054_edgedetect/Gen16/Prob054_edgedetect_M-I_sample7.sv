module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;

    // At every clock, store the current input for next cycle comparison
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Register pedge output to improve timing
    always @(posedge clk) begin
        // Detect positive edge: prev_in=0, in=1
        pedge <= (~prev_in) & in;
    end

endmodule