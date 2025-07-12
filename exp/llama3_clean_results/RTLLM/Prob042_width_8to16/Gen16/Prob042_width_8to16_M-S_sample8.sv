module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] locked_data;
reg valid_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        locked_data <= 8'b0;
        valid_lock <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;
        if (valid_in) begin
            if (valid_lock) begin
                data_out <= {locked_data, data_in};
                valid_out <= 1'b1;
                valid_lock <= 1'b0;
            end else begin
                locked_data <= data_in;
                valid_lock <= 1'b1;
            end
        end else begin
            valid_lock <= valid_lock;
        end
    end
end

endmodule