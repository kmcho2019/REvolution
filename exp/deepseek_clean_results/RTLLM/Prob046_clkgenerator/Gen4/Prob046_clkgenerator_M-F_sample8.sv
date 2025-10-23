module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk,
    input ref_clk,    // Reference clock input
    input reset_n     // Active-low reset
);

    // Calculate counter maximum value (half period)
    localparam HALF_PERIOD = (PERIOD + 1) / 2; // Handles both even/odd periods
    localparam COUNTER_WIDTH = $clog2(HALF_PERIOD + 1);
    
    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge ref_clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk <= 1'b0;
        end
        else begin
            if (counter == HALF_PERIOD - 1) begin
                counter <= 0;
                clk <= ~clk;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

    // Parameter validation
    initial begin
        if (PERIOD < 2) begin
            $error("PERIOD must be at least 2");
        end
        if (PERIOD % 2 != 0) begin
            $warning("PERIOD is odd - duty cycle will not be exactly 50%%");
        end
    end
endmodule