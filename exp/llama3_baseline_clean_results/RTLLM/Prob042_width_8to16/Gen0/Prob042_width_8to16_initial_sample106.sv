module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg [7:0] data_in_reg;
reg first_data_received;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 0;
        data_out <= 0;
        first_data_received <= 0;
        data_lock <= 0;
    end else begin
        if (valid_in && !first_data_received) begin
            data_lock <= data_in;
            first_data_received <= 1;
        end else if (valid_in && first_data_received) begin
            data_in_reg <= data_in;
            data_out <= {data_lock, data_in_reg};
            valid_out <= 1;
            first_data_received <= 0;
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule