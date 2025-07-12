module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg [7:0] data_in_reg;
reg valid_out_reg;
reg [15:0] data_out_reg;
reg first_data_arrived;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        data_in_reg <= 8'd0;
        valid_out_reg <= 1'd0;
        data_out_reg <= 16'd0;
        first_data_arrived <= 1'd0;
    end else if (valid_in) begin
        if (!first_data_arrived) begin
            data_lock <= data_in;
            first_data_arrived <= 1'd1;
        end else begin
            data_in_reg <= data_in;
            valid_out_reg <= 1'd1;
            data_out_reg <= {data_lock, data_in_reg};
            first_data_arrived <= 1'd0;
        end
    end else begin
        valid_out_reg <= 1'd0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule