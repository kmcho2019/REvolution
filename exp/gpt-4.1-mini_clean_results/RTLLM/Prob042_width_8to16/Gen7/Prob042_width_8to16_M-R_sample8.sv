module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;     // to hold first data input
    reg       data_flag;     // 0: waiting for first byte, 1: waiting for second byte
    reg       valid_out_d;   // delayed valid flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
            data_flag  <= 1'b0;
            valid_out_d <= 1'b0;
        end else begin
            valid_out <= valid_out_d;  // output valid delayed by one cycle
            
            if (valid_in) begin
                if (data_flag == 1'b0) begin
                    // first byte received, store in upper bits
                    data_lock <= data_in;
                    valid_out_d <= 1'b0;   // no valid output yet
                    data_flag <= 1'b1;
                end else begin
                    // second byte received, concatenate and output next cycle
                    data_out <= {data_lock, data_in};
                    valid_out_d <= 1'b1;   // assert valid next cycle
                    data_flag <= 1'b0;
                end
            end else begin
                // no new input
                valid_out_d <= 1'b0;
            end
        end
    end

endmodule