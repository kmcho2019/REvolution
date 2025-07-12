module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter
reg [1:0] state;  // State machine state
reg        clk_div_int;  // Internal clock divider
reg        rising_edge;  // Rising edge counter
reg        falling_edge;  // Falling edge counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        state <= 0;
        clk_div_int <= 1'b0;
        rising_edge <= 1'b0;
        falling_edge <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // Counting state
                if (cnt == (NUM_DIV - 1)) begin
                    state <= 2'b01;
                    cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                if (rising_edge) begin
                    rising_edge <= 1'b0;
                end else begin
                    rising_edge <= 1'b1;
                end
                if (falling_edge) begin
                    falling_edge <= 1'b0;
                end else begin
                    falling_edge <= 1'b1;
                end
            end
            2'b01: begin  // Toggling state
                state <= 2'b00;
                clk_div_int <= ~clk_div_int;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

assign clk_div = (rising_edge || falling_edge) && clk_div_int;

endmodule