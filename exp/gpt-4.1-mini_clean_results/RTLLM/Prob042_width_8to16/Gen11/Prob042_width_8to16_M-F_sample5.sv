module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;       // Holds first 8-bit data
    reg        flag;            // Indicates if first data is stored (1) or not (0)

    reg [15:0] data_out_reg;    // Pipeline register for output data (concatenated)
    reg        valid_out_reg;   // Pipeline register for output valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            flag          <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out_reg <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            // Default deassert output valid; will be updated from pipeline reg
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;

            valid_out_reg <= 1'b0; // Clear pipeline valid; only asserted on new concatenation

            if (valid_in) begin
                if (flag == 1'b0) begin
                    // Store first 8-bit input
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Second valid input arrived, concatenate and prepare output next cycle
                    data_out_reg  <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;

                    // Reset flag to wait for next first input
                    flag <= 1'b0;
                end
            end
        end
    end

endmodule