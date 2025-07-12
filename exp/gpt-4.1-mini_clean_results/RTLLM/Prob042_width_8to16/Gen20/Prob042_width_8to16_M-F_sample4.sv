module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;
    reg        has_data;

    // Pipeline registers for delayed output
    reg        valid_next;
    reg [15:0] data_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            has_data   <= 1'b0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
            valid_next <= 1'b0;
            data_next  <= 16'd0;
        end else begin
            valid_out  <= valid_next;
            data_out   <= data_next;
            valid_next <= 1'b0;  // default no valid output each cycle

            if (valid_in) begin
                if (!has_data) begin
                    // First valid input stored
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // Second valid input: prepare output for next cycle
                    data_next  <= {data_lock, data_in};
                    valid_next <= 1'b1;
                    has_data   <= 1'b0; // ready for next pair
                end
            end
        end
    end

endmodule