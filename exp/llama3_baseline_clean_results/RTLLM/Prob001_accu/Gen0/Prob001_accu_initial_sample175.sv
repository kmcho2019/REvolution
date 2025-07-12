module accu(
    input           clk,        // Clock input for synchronization
    input           rst_n,      // Active-low reset signal
    input   [7:0]   data_in,    // 8-bit input data for addition
    input           valid_in,   // Input signal indicating readiness for new data
    output          valid_out,  // Output signal indicating when 4 input data accumulation is reached
    output  [9:0]   data_out    // 10-bit output data representing the accumulated sum
);

reg     [9:0]   accu_reg;      // Register to hold the accumulated sum
reg     [1:0]   cnt_reg;       // Register to count the number of valid inputs
reg             valid_out_reg; // Register to hold the valid_out signal

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accu_reg    <= 10'd0;
        cnt_reg     <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            // Accumulate data when valid_in is high
            if (cnt_reg < 2'd3) begin
                accu_reg <= accu_reg + data_in;
                cnt_reg  <= cnt_reg + 1'd1;
            end else begin
                // When four valid data are received, set valid_out and reset counters
                accu_reg    <= accu_reg + data_in;
                valid_out_reg <= 1'b1;
                cnt_reg     <= 2'd0;
            end
        end else begin
            // Reset valid_out after one cycle
            if (valid_out_reg) begin
                valid_out_reg <= 1'b0;
            end
        end
    end
end

// Output assignments
assign valid_out = valid_out_reg;
assign data_out  = (valid_out_reg) ? accu_reg : 10'd0;

endmodule