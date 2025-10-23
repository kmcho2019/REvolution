module freq_diveven (
    input wire clk,
    input wire rst_n,        // Synchronous reset (active low)
    input wire enable,      // Clock gating enable
    output wire clk_div     // Glitch-free divided clock
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;

// Validate parameter at elaboration
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

// Calculate required counter width (log2(NUM_DIV/2))
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_INIT = (NUM_DIV/2) - 1;

reg [COUNTER_WIDTH-1:0] cnt;
reg div_reg;

// Down counter implementation
always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= COUNT_INIT;
        div_reg <= 1'b0;
    end
    else if (enable) begin
        if (cnt == 0) begin
            cnt <= COUNT_INIT;
            div_reg <= ~div_reg;
        end
        else begin
            cnt <= cnt - 1;
        end
    end
end

// Registered output for glitch-free operation
assign clk_div = div_reg;

endmodule