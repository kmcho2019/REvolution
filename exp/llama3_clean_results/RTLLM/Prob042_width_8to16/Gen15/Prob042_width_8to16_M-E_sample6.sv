module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_buffer1;
reg [7:0] data_buffer2;
reg [15:0] data_out_buffer;
reg [1:0] data_valid_count;
reg valid_out_reg;

assign valid_out = valid_out_reg;
assign data_out = data_out_buffer;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_buffer1 <= 8'd0;
        data_buffer2 <= 8'd0;
        data_out_buffer <= 16'd0;
        data_valid_count <= 2'd0;
        valid_out_reg <= 1'b0;
    end
    else begin
        // Input Buffering
        if (valid_in) begin
            if (data_valid_count == 2'd0) begin
                data_buffer1 <= data_in;
                data_valid_count <= 2'd1;
            end
            else if (data_valid_count == 2'd1) begin
                data_buffer2 <= data_in;
                data_valid_count <= 2'd2;
            end
        end
        
        // Pipeline Stage
        if (data_valid_count == 2'd2) begin
            data_out_buffer <= {data_buffer1, data_buffer2};
            valid_out_reg <= 1'b1;
            data_valid_count <= 2'd0;
        end
        else begin
            valid_out_reg <= 1'b0;
        end
    end
end

endmodule