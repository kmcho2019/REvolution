module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock_reg;
reg valid_out_reg;
reg locked;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock_reg <= 8'b0;
        valid_out_reg <= 1'b0;
        locked <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (!locked) begin
                locked <= 1'b1;
                data_lock_reg <= data_in;
            end else begin
                data_out <= {data_lock_reg, data_in};
                valid_out_reg <= 1'b1;
                locked <= 1'b0;
            end
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;

endmodule