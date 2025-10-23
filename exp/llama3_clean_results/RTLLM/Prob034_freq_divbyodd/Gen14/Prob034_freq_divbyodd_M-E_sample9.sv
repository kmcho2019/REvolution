module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [2:0] state;  // State machine state
reg [2:0] cnt1;   // Counter for rising edge
reg [2:0] cnt2;   // Counter for falling edge
reg        clk_div1;  // Clock divider for rising edge
reg        clk_div2;  // Clock divider for falling edge

localparam half_div = NUM_DIV / 2;  // Half divisor value

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        case (state)
            0: begin  // IDLE state
                if (cnt1 == half_div) begin
                    state <= 1;
                    cnt1 <= 0;
                    clk_div1 <= ~clk_div1;
                end else if (cnt2 == half_div) begin
                    state <= 1;
                    cnt2 <= 0;
                    clk_div2 <= ~clk_div2;
                end else begin
                    cnt1 <= cnt1 + 1;
                    cnt2 <= cnt2 + 1;
                end
            end
            1: begin  // DIVIDE state
                if (cnt1 == NUM_DIV - 1) begin
                    state <= 0;
                    cnt1 <= 0;
                end else if (cnt2 == NUM_DIV - 1) begin
                    state <= 0;
                    cnt2 <= 0;
                end else begin
                    cnt1 <= cnt1 + 1;
                    cnt2 <= cnt2 + 1;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule