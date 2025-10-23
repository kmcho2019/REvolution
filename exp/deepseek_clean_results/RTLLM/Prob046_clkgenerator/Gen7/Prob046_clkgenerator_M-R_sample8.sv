module clkgenerator #(
    parameter PERIOD = 10       // Clock period in base clock cycles (must be even)
)(
    input wire clk_base,        // Base clock input
    input wire reset_n,         // Active-low reset (synchronous)
    output wire clk             // Generated clock output
);

    // Validate parameter (PERIOD must be even for 50% duty cycle)
    initial begin
        if (PERIOD % 2 != 0) begin
            $error("PERIOD must be even for 50%% duty cycle");
            $finish;
        end
    end

    // Calculate required counter width and half period
    localparam HALF_PERIOD = PERIOD / 2;
    localparam COUNTER_WIDTH = $clog2(HALF_PERIOD);
    
    reg [COUNTER_WIDTH-1:0] counter;
    reg clk_reg;
    
    // Combinational logic for next counter value
    wire [COUNTER_WIDTH-1:0] next_counter = (counter == 0) ? (HALF_PERIOD - 1) : (counter - 1);
    wire next_clk = (counter == 0) ? ~clk_reg : clk_reg;

    // Sequential logic (flip-flops)
    always @(posedge clk_base) begin
        if (!reset_n) begin
            counter <= HALF_PERIOD - 1;
            clk_reg <= 1'b0;
        end
        else begin
            counter <= next_counter;
            clk_reg <= next_clk;
        end
    end

    assign clk = clk_reg;

endmodule