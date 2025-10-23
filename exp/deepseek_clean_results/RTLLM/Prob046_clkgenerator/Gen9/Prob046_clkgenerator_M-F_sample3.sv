module clkgenerator #(
    parameter PERIOD = 10
) (
    input wire reset_n,    // Active-low reset
    input wire enable,     // Clock enable control
    output reg clk         // Generated clock output
);

    // Validate parameter and calculate half period
    initial begin
        if (PERIOD % 2 != 0) begin
            $display("Error: PERIOD must be even for 50%% duty cycle");
            $finish;
        end
    end

    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation process
    always begin
        if (!reset_n) begin
            clk <= 1'b0;  // Reset clock to 0
            @(posedge reset_n); // Wait for reset to deassert
        end
        else if (enable) begin
            #HALF_PERIOD clk <= ~clk;  // Toggle clock
        end
        else begin
            clk <= 1'b0;  // Hold clock low when disabled
            @(posedge enable); // Wait for enable
        end
    end

endmodule