module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active high
    output wire shift_ena
);

    reg [2:0] count;
    reg reset_sync;

    always @(posedge clk) begin
        // Synchronize reset signal to detect deassertion edge internally
        reset_sync <= reset;

        if (reset) begin
            // Load counter with 4 on synchronous reset
            count <= 3'd4;
        end else if (reset_sync && !reset) begin
            // Just after reset deassertion, start counting down from 4 on next cycles
            // Actually this edge is already handled by counter loaded at reset,
            // so no action needed here.
            // Keeping this here for clarity, but no else needed
            count <= count;
        end else if (count != 0) begin
            count <= count - 1;
        end
    end

    assign shift_ena = (count != 0);

endmodule