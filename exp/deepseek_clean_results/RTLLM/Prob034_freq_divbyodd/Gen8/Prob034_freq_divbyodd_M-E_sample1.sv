module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam STATE_WIDTH = $clog2(2*NUM_DIV);
    reg [STATE_WIDTH-1:0] current_state, next_state;
    reg toggle;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= 0;
            toggle <= 0;
        end else begin
            current_state <= next_state;
            // Toggle at specific states to maintain 50% duty cycle
            if (next_state == (NUM_DIV-1)/2 || next_state == NUM_DIV + (NUM_DIV-1)/2) begin
                toggle <= ~toggle;
            end
        end
    end

    // Next state logic (counts on both edges)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            next_state <= 0;
        end else begin
            next_state <= (current_state == 2*NUM_DIV-1) ? 0 : current_state + 1;
        end
    end

    // Output logic
    always @(*) begin
        clk_div = toggle;
    end

endmodule