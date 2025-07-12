module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;       // Stores first byte
reg       flag;            // Indicates first byte is stored
reg       output_pending;  // Indicates output should be asserted next cycle
reg [15:0] data_out_next; // Holds the concatenated output for next cycle

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock      <= 8'd0;
        flag           <= 1'b0;
        output_pending <= 1'b0;
        data_out       <= 16'd0;
        valid_out      <= 1'b0;
        data_out_next  <= 16'd0;
    end else begin
        valid_out <= output_pending;
        data_out  <= output_pending ? data_out_next : data_out;

        output_pending <= 1'b0; // Default: no output pending

        if (valid_in) begin
            if (!flag) begin
                // First byte: store it and set flag
                data_lock <= data_in;
                flag      <= 1'b1;
            end else begin
                // Second byte: prepare output for next cycle
                data_out_next  <= {data_lock, data_in};
                output_pending <= 1'b1;
                flag           <= 1'b0; // Clear flag after second byte
            end
        end
    end
end

endmodule