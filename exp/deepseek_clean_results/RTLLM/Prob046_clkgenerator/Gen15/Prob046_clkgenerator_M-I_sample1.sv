module clkgenerator #(
    parameter PERIOD = 10
)(
    input sys_clk,      // System clock input
    input rst_n,        // Active-low reset
    output reg clk_out  // Generated clock output
);

    reg [$clog2(PERIOD)-1:0] counter;

    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == PERIOD-1) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
                // Toggle at half period for 50% duty cycle
                if (counter == (PERIOD/2)-1)
                    clk_out <= ~clk_out;
            end
        end
    end

endmodule