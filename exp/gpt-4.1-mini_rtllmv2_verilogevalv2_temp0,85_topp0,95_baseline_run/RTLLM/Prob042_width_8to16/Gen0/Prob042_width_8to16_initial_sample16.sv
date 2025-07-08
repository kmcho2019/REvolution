module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output  reg         valid_out,
    output  reg [15:0]  data_out
);

    reg [7:0] data_lock;
    reg       flag;
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock   <= 8'b0;
            flag        <= 1'b0;
            data_out    <= 16'b0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;
            if (valid_in) begin
                if (!flag) begin
                    data_lock <= data_in;
                    flag      <= 1'b1;
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'b0;
                end else begin
                    // Second valid data input, form output next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    flag           <= 1'b0; // Clear flag after output
                end
            end else begin
                // No valid input, keep next outputs as zero
                valid_out_next <= 1'b0;
                data_out_next  <= 16'b0;
            end
        end
    end

endmodule