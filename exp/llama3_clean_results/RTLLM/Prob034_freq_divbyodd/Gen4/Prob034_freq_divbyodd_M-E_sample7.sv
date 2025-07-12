module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter for clock cycles
reg        clk_div_int;  // Internal divided clock
reg [1:0] state;  // State machine state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
        state <= 2'b00;  // Idle state
    end else begin
        case (state)
            2'b00: begin  // Idle state
                cnt <= 0;
                state <= 2'b01;  // Transition to count state
            end
            2'b01: begin  // Count state
                if (cnt == (NUM_DIV / 2) - 1) begin
                    cnt <= 0;
                    state <= 2'b10;  // Transition to toggle state
                end else begin
                    cnt <= cnt + 1;
                end
            end
            2'b10: begin  // Toggle state
                clk_div_int <= ~clk_div_int;
                state <= 2'b01;  // Transition back to count state
            end
            default: begin
                state <= 2'b00;  // Default to idle state
            end
        endcase
    end
end

assign clk_div = clk_div_int;

endmodule