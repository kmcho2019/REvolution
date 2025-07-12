module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;         // stores the first 8-bit data
    reg        flag;              // 0: waiting for first data; 1: first data stored
    reg [15:0] data_out_reg;      // intermediate register for output data
    reg        valid_out_reg;     // intermediate register for output valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            flag          <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out_reg <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            // Default output valid to 0 (will be updated if data available)
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
            valid_out_reg <= 1'b0;  // clear intermediate valid after outputting

            if (valid_in) begin
                if (flag == 1'b0) begin
                    // First valid data received: latch it and set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Second valid data received: concatenate with first and prepare outputs next cycle
                    data_out_reg  <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    flag <= 1'b0; // Reset flag for next pair
                end
            end
        end
    end

endmodule