module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_CYCLE = (NUM_DIV - 1)/2;

// State machine registers
reg [31:0] state;
reg toggle;

// State machine for both edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        toggle <= 0;
        clk_div <= 0;
    end else begin
        // State progression
        if (state == NUM_DIV - 1) begin
            state <= 0;
        end else begin
            state <= state + 1;
        end

        // Toggle control
        if (state == HALF_CYCLE) begin
            toggle <= 1;
        end else if (state == NUM_DIV - 1) begin
            toggle <= 0;
        end

        // Output generation
        if (toggle) begin
            clk_div <= 1;
        end else begin
            clk_div <= 0;
        end
    end
end

endmodule