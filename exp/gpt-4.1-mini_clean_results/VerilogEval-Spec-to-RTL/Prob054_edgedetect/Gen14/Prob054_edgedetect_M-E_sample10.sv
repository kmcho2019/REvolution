module TopModule (
    input             clk,
    input      [7:0]  in,
    output reg [7:0]  pedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect 0->1 transition by checking bits that are 1 now and were 0 before
        pedge <= (~prev_in) & in;
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule