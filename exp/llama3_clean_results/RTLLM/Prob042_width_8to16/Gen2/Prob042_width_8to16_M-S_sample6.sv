module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        if (valid_in) begin
            if (data_lock == 0) begin
                data_lock <= data_in;
                valid_out <= 0;
                data_out <= 0;
            end else begin
                valid_out <= 1;
                data_out <= {data_lock, data_in};
                data_lock <= 0;
            end
        end else begin
            valid_out <= 0;
            data_out <= 0;
        end
    end
end

endmodule