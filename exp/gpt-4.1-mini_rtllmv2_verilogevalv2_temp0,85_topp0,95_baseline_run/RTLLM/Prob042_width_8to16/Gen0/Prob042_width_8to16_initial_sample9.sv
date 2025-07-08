module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg       flag;       // Indicates if first data is stored
reg       output_en;  // To generate valid_out and data_out in next cycle after second data input

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock  <= 8'd0;
        flag       <= 1'b0;
        valid_out  <= 1'b0;
        data_out   <= 16'd0;
        output_en  <= 1'b0;
    end else begin
        valid_out <= 1'b0;  // Default, valid_out only asserted when output_en is set

        if (output_en) begin
            // Output data was already prepared in previous cycle
            valid_out <= 1'b1;
            output_en <= 1'b0;
        end else if (valid_in) begin
            if (!flag) begin
                // First valid input arrived, store it
                data_lock <= data_in;
                flag <= 1'b1;
            end else begin
                // Second valid input arrived, prepare output in next cycle
                data_out <= {data_lock, data_in};
                flag <= 1'b0;
                output_en <= 1'b1;
            end
        end
    end
end

endmodule