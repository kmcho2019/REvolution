module width_8to16 (
    input wire        clk,
    input wire        rst_n,
    input wire        valid_in,
    input wire [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;      // 0: no stored data; 1: data stored in data_lock
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock   <= 8'b0;
            flag        <= 1'b0;
            valid_out   <= 1'b0;
            data_out    <= 16'b0;
        end else begin
            // Default output values to zero each cycle before update
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (!flag) begin
                    // First valid data: store it and set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                    // No output yet
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'b0;
                end else begin
                    // Second valid data: output concatenated data
                    valid_out_next <= 1'b1;
                    data_out_next  <= {data_lock, data_in};
                    // Clear flag for next pair
                    flag <= 1'b0;
                end
            end else begin
                // No valid input, output valid_out_next and data_out_next unchanged,
                // but we must keep valid_out and data_out stable until next update
                valid_out_next <= 1'b0;
                data_out_next  <= 16'b0;
            end
        end
    end

endmodule