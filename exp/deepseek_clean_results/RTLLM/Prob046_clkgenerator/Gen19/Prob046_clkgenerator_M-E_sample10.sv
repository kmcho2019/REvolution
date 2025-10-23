module clkgenerator #(
    parameter PERIOD = 10
)(
    input wire rst_n,        // Active-low synchronous reset
    output reg clk = 1'b0    // Clock output initialized to 0
);

    // Counter to track clock cycles
    reg [31:0] counter = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            clk <= 1'b0;
            counter <= 0;
        end
        else begin
            // Increment counter and toggle clock at half period
            counter <= counter + 1;
            if (counter >= (PERIOD/2 - 1)) begin
                clk <= ~clk;
                counter <= 0;
            end
        end
    end

    // Initial clock generation (only for simulation)
    initial begin
        // Wait until we get out of reset
        @(negedge rst_n);
        // Generate first clock edge after reset
        #(PERIOD/2) clk = 1'b1;
    end

endmodule