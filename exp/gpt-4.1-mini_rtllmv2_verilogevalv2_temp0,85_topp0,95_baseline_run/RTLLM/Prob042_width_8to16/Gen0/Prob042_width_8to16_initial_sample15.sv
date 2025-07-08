module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;       // Indicates one 8-bit data stored, waiting for next

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 8'd0;
            flag       <= 1'b0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            valid_out <= 1'b0; // Default no valid output each cycle

            if (valid_in) begin
                if (!flag) begin
                    // First data input: store and set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second data input: output concatenated result next cycle
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    flag      <= 1'b0;
                end
            end
        end
    end

endmodule