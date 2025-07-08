module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg flag;               // Indicates if data_lock holds valid data
    reg valid_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock    <= 8'd0;
            flag         <= 1'b0;
            data_out     <= 16'd0;
            valid_out    <= 1'b0;
            valid_out_next <= 1'b0;
        end else begin
            valid_out <= valid_out_next;
            valid_out_next <= 1'b0;

            if (valid_in) begin
                if (!flag) begin
                    // Store the first 8-bit data
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Concatenate the stored data_lock and current data_in
                    data_out <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    flag <= 1'b0;  // Clear flag after outputting data_out
                end
            end
        end
    end

endmodule