module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       has_data;

    reg [15:0] output_reg;
    reg        valid_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            has_data       <= 1'b0;
            output_reg     <= 16'd0;
            valid_out_reg  <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
        end else begin
            valid_out      <= valid_out_reg;
            data_out       <= output_reg;

            valid_out_reg  <= 1'b0; // default no valid output

            if (valid_in) begin
                if (!has_data) begin
                    // Store first input
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // Second input arrived: concatenate and output next cycle
                    output_reg    <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    has_data     <= 1'b0;  // Clear stored data
                end
            end
            // If no valid_in, keep state as is and valid_out_reg=0
        end
    end

endmodule