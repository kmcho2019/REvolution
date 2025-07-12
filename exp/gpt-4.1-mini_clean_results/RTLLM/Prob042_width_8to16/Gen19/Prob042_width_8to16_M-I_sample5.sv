module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output reg     valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;  // Holds first 8-bit data input
    reg        flag;       // Indicates if data_lock is occupied with first input
    reg [15:0] data_next;  // Holds concatenated data temporarily for output next cycle
    reg        valid_next; // Indicates if data_next is valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            flag       <= 1'b0;
            data_next  <= 16'd0;
            valid_next <= 1'b0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            valid_out  <= valid_next;
            data_out   <= data_next;
            valid_next <= 1'b0;  // Default to no valid output next cycle

            if (valid_in) begin
                if (!flag) begin
                    // First valid input received; store it
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second valid input received; concatenate and prepare output next cycle
                    data_next  <= {data_lock, data_in};
                    valid_next <= 1'b1;
                    flag       <= 1'b0; // Clear flag to accept next first data
                end
            end
        end
    end

endmodule