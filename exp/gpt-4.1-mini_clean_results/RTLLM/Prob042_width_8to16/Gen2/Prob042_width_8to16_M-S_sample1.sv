module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;           // Store first byte
reg       waiting_second_byte; // State flag: 0 = waiting first byte, 1 = waiting second byte

reg       output_valid_d;      // Registered output valid
reg [15:0] output_data_d;      // Registered output data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock          <= 8'd0;
        waiting_second_byte <= 1'b0;
        output_valid_d     <= 1'b0;
        output_data_d      <= 16'd0;
        valid_out          <= 1'b0;
        data_out           <= 16'd0;
    end else begin
        valid_out <= output_valid_d;
        data_out  <= output_data_d;

        output_valid_d <= 1'b0; // Default no valid output unless updated below

        if (valid_in) begin
            if (!waiting_second_byte) begin
                // First byte: store and wait for second
                data_lock          <= data_in;
                waiting_second_byte <= 1'b1;
            end else begin
                // Second byte: prepare output for next cycle
                output_data_d      <= {data_lock, data_in};
                output_valid_d     <= 1'b1;
                waiting_second_byte <= 1'b0;
            end
        end
    end
end

endmodule