module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_delayed;
    wire edge_pulse;

    // Create a small delay in the clock signal
    assign #1 clk_delayed = clk;

    // XOR creates a pulse on both edges
    assign edge_pulse = clk ^ clk_delayed;

    // Capture data on both edges
    always @(posedge edge_pulse) begin
        q <= d;
    end

endmodule