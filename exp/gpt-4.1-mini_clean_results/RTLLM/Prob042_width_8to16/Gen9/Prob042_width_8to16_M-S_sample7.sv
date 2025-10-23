module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;        // holds first 8-bit input
    reg [7:0] data_in_second;   // holds second 8-bit input
    reg       flag;             // 0: waiting first data; 1: first data latched

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            data_in_second<= 8'd0;
            flag          <= 1'b0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            valid_out <= 1'b0;  // default no valid output this cycle
            
            if (valid_in) begin
                if (flag == 1'b0) begin
                    // latch first data and set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // latch second data, output concatenated data next cycle
                    data_in_second <= data_in;
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    flag <= 1'b0; // reset flag for next pair
                end
            end
        end
    end

endmodule