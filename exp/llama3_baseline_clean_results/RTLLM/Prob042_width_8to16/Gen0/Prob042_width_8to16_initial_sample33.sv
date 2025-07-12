module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 0;
        data_out <= 0;
        data_lock <= 0;
        flag <= 0;
    end else begin
        if (valid_in && !flag) begin
            data_lock <= data_in;
            flag <= 1;
        end else if (valid_in && flag) begin
            data_out <= {data_lock, data_in};
            valid_out <= 1;
            flag <= 0;
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule