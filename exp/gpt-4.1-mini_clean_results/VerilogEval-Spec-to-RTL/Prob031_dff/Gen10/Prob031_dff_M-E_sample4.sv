module TopModule (
    input wire clk,
    input wire d,
    output reg q
);
    // Internal synchronous reset signal, permanently 0 (inactive)
    wire reset_sync = 1'b0;

    // Sequential logic using always_ff (SystemVerilog style)
    always_ff @(posedge clk) begin
        if (reset_sync)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule