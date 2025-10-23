module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
            flag       <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default no valid output each cycle

            if (valid_in) begin
                if (flag == 1'b0) begin
                    // Store first data, wait for next
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Concatenate stored data and new data, output next cycle
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    flag <= 1'b0;
                end
            end
        end
    end

endmodule