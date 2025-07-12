module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >=3
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV < 3 || NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_CYCLE = (NUM_DIV - 1)/2;

reg [CNT_WIDTH-1:0] counter;
reg toggle_a;
reg toggle_b;

// Single counter on positive edge only
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// First toggle at half cycle (rising edge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle_a <= 0;
    end else if (counter == HALF_CYCLE) begin
        toggle_a <= ~toggle_a;
    end
end

// Second toggle at full cycle (falling edge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle_b <= 0;
    end else if (counter == NUM_DIV - 1) begin
        toggle_b <= ~toggle_b;
    end
end

// Combine to create 50% duty cycle
assign clk_div = toggle_a ^ toggle_b;

endmodule