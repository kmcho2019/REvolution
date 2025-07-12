module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    reg [7:0]  data_lock;    // Holds the first 8-bit input
    reg        flag;         // Indicates whether first data is stored

    reg        valid_out_d;  // Delayed valid_out signal to generate output in next cycle
    reg [15:0] data_out_d;   // Delayed data_out register for next cycle output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock   <= 8'd0;
            flag        <= 1'b0;
            valid_out   <= 1'b0;
            valid_out_d <= 1'b0;
            data_out    <= 16'd0;
            data_out_d  <= 16'd0;
        end else begin
            // Default valid_out is previous cycle's delayed valid
            valid_out <= valid_out_d;
            data_out  <= data_out_d;

            valid_out_d <= 1'b0;  // Default no valid output this cycle

            if (valid_in) begin
                if (!flag) begin
                    // First valid data received: store it and set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Second valid data received: concatenate and prepare output next cycle
                    data_out_d  <= {data_lock, data_in};
                    valid_out_d <= 1'b1;
                    flag <= 1'b0;  // Clear flag to accept new first data
                end
            end
        end
    end

endmodule