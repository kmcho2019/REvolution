module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stage1_data;
reg [7:0] stage2_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_data <= 8'b0;
        stage2_data <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            stage1_data <= data_in;
        end
        
        if (stage1_data!= 8'b0 && valid_in) begin
            stage2_data <= data_in;
            data_out <= {stage1_data, stage2_data};
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
        
        if (valid_out) begin
            stage1_data <= 8'b0;
            stage2_data <= 8'b0;
        end
    end
end

endmodule