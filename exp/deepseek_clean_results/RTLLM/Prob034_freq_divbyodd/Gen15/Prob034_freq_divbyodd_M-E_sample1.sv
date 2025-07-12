module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam COUNT_MAX = NUM_DIV - 1;
localparam PHASE_POINT = (NUM_DIV - 1)/2;

reg [31:0] edge_counter;
reg phase_a;
reg phase_b;

// Dual-edge counter (counts both rising and falling edges)
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        edge_counter <= 0;
        phase_a <= 0;
        phase_b <= 0;
    end else begin
        // Counter logic
        if (edge_counter == COUNT_MAX) begin
            edge_counter <= 0;
        end else begin
            edge_counter <= edge_counter + 1;
        end

        // Phase A enable (first half cycle)
        if (edge_counter == PHASE_POINT) begin
            phase_a <= 1;
        end else if (edge_counter == COUNT_MAX) begin
            phase_a <= 0;
        end

        // Phase B enable (second half cycle)
        if (edge_counter == COUNT_MAX) begin
            phase_b <= 1;
        end else if (edge_counter == PHASE_POINT) begin
            phase_b <= 0;
        end
    end
end

// Combine phases to create final output
assign clk_div = phase_a ^ phase_b;

endmodule