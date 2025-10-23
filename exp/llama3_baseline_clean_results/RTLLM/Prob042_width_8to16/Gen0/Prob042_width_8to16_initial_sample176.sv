module width_8to16(
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg       data_valid;
reg       valid_out_reg;
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock     <= 8'd0;
        data_valid   <= 1'd0;
        valid_out_reg <= 1'd0;
        data_out_reg  <= 16'd0;
    end else begin
        if (valid_in) begin
            if (!data_valid) begin
                // Store the first valid data
                data_lock     <= data_in;
                data_valid   <= 1'd1;
                valid_out_reg <= 1'd0;
            end else begin
                // Concatenate and output
                data_out_reg  <= {data_lock, data_in};
                valid_out_reg <= 1'd1;
                data_valid   <= 1'd0; // Reset the flag
            end
        end else begin
            valid_out_reg <= 1'd0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule