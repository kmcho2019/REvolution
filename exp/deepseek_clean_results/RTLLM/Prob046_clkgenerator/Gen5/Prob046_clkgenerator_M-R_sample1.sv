module clkgenerator #(
    parameter PERIOD = 10
) (
    output wire clk,
    input ref_clk,
    input reset_n
);

    // Calculate counter parameters
    localparam HALF_PERIOD = (PERIOD + 1) / 2;
    localparam COUNTER_WIDTH = $clog2(HALF_PERIOD + 1);
    
    reg [COUNTER_WIDTH-1:0] counter;
    reg [COUNTER_WIDTH-1:0] next_counter;
    reg clk_reg;
    reg next_clk;

    // Continuous assignment for clock output
    assign clk = clk_reg;

    // Combinational next-state logic
    always @(*) begin
        if (counter == HALF_PERIOD - 1) begin
            next_counter = 0;
            next_clk = ~clk_reg;
        end else begin
            next_counter = counter + 1;
            next_clk = clk_reg;
        end
    end

    // Sequential state update
    always @(posedge ref_clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk_reg <= 1'b0;
        end else begin
            counter <= next_counter;
            clk_reg <= next_clk;
        end
    end

    // Parameter validation (unchanged)
    initial begin
        if (PERIOD < 2) begin
            $error("PERIOD must be at least 2");
        end
        if (PERIOD % 2 != 0) begin
            $warning("PERIOD is odd - duty cycle will not be exactly 50%%");
        end
    end
endmodule