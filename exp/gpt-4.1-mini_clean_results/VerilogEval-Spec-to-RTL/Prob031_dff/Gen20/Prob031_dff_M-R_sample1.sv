module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    // No asynchronous reset; q simply updates to d at posedge clk.
    // This style embeds the flip-flop directly inside the top module.
    always @(posedge clk) begin
        q <= d;
    end

endmodule