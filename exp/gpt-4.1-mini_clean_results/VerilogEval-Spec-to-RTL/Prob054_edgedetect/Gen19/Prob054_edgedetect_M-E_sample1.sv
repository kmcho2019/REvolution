module TopModule (
    input            clk,
    input      [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] delayed_in;

    always @(posedge clk) begin
        delayed_in <= in;             // Register the input to delay by one cycle
        pedge      <= (~delayed_in) & in;  // Positive edge detection: 0->1 transition
    end

endmodule