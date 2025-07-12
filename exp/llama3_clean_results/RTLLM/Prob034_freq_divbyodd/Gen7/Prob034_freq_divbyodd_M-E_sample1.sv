module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter for clock cycles
reg        clk_div_int;  // Internal clock divider
reg [1:0]  phase_buf;  // Phase alignment buffer

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
        phase_buf <= 2'b00;
    end else begin
        // Update phase alignment buffer
        phase_buf <= {phase_buf[0], clk};
        
        // Increment counter
        cnt <= (cnt == (NUM_DIV - 1)) ? 0 : cnt + 1;
        
        // Toggle clock divider
        if (cnt == (NUM_DIV - 1)) begin
            clk_div_int <= ~clk_div_int;
        end
    end
end

// Generate divided clock based on phase alignment
assign clk_div = (phase_buf[1] && clk_div_int) || (phase_buf[0] && ~clk_div_int);

endmodule