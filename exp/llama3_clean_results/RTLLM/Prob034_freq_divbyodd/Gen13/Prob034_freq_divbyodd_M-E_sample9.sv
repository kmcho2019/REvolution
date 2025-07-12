module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt1;  // Counter for rising edges
reg [31:0] cnt2;  // Counter for falling edges
reg        clk_div1;  // Clock divider for rising edges
reg        clk_div2;  // Clock divider for falling edges
reg [1:0]  fsm_state;  // Finite state machine state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        fsm_state <= 2'b00;
    end else begin
        case (fsm_state)
            2'b00: begin
                cnt1 <= (cnt1 == (NUM_DIV / 2 - 1)) ? 0 : cnt1 + 1;
                if (cnt1 == (NUM_DIV / 2 - 1)) begin
                    clk_div1 <= ~clk_div1;
                    fsm_state <= 2'b01;
                end
            end
            2'b01: begin
                cnt2 <= (cnt2 == (NUM_DIV / 2 - 1)) ? 0 : cnt2 + 1;
                if (cnt2 == (NUM_DIV / 2 - 1)) begin
                    clk_div2 <= ~clk_div2;
                    fsm_state <= 2'b00;
                end
            end
        endcase
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule