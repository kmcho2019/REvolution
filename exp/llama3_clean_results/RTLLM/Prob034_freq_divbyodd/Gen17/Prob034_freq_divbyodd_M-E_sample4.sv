module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter
reg        clk_div_int;  // Internal divided clock output
reg        rising_edge;  // Rising edge detector
reg        falling_edge;  // Falling edge detector
reg        state;  // State machine state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
        rising_edge <= 1'b0;
        falling_edge <= 1'b0;
        state <= 0;
    end else begin
        // Clock edge detector
        rising_edge <= clk && ~state;
        falling_edge <= ~clk && state;
        
        // State machine
        if (state == 0) begin
            if (rising_edge) begin
                state <= 1;
                cnt <= 0;
            end
        end else if (state == 1) begin
            if (cnt == (NUM_DIV - 1)) begin
                state <= 0;
                cnt <= 0;
                clk_div_int <= ~clk_div_int;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
end

assign clk_div = clk_div_int;

endmodule