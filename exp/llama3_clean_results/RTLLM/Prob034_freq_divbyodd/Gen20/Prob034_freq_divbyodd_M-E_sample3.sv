module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [1:0] state;  // State machine state
reg [31:0] cnt_rising;  // Counter for rising edges
reg [31:0] cnt_falling;  // Counter for falling edges
reg        clk_div1;  // Clock divider output for rising edges
reg        clk_div2;  // Clock divider output for falling edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;  // Reset state machine to initial state
        cnt_rising <= 0;
        cnt_falling <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // COUNT_RISING state
                if (cnt_rising == (NUM_DIV / 2 - 1)) begin
                    cnt_rising <= 0;
                    clk_div1 <= ~clk_div1;
                    state <= 2'b01;  // Transition to COUNT_FALLING state
                end else begin
                    cnt_rising <= cnt_rising + 1;
                end
            end
            2'b01: begin  // COUNT_FALLING state
                if (cnt_falling == (NUM_DIV / 2 - 1)) begin
                    cnt_falling <= 0;
                    clk_div2 <= ~clk_div2;
                    state <= 2'b00;  // Transition to COUNT_RISING state
                end else begin
                    cnt_falling <= cnt_falling + 1;
                end
            end
            default: begin
                state <= 2'b00;  // Reset state machine to initial state
            end
        endcase
    end
end

assign clk_div = clk_div1 | clk_div2;  // Final divided clock output

endmodule