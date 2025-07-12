module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

localparam CNT_WIDTH = $clog2(NUM_DIV);  // Dynamic counter width
localparam NUM_STATES = 2;  // Number of FSM states
localparam STATE_COUNT = 0;  // Counting state
localparam STATE_TOGGLE = 1;  // Toggle state

reg [CNT_WIDTH-1:0] cnt;  // Counter
reg [NUM_STATES-1:0] curr_state;  // Current FSM state
reg        clk_div_int;  // Internal clock divider output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        curr_state <= STATE_COUNT;
        clk_div_int <= 1'b0;
    end else begin
        case (curr_state)
            STATE_COUNT: begin
                // Update counter
                if (cnt < (NUM_DIV / 2)) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 0;
                    curr_state <= STATE_TOGGLE;
                end
            end
            STATE_TOGGLE: begin
                // Toggle divided clock output and reset counter
                clk_div_int <= ~clk_div_int;
                curr_state <= STATE_COUNT;
            end
        endcase
    end
end

assign clk_div = clk_div_int;

endmodule