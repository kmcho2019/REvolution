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
        flag <= 0;
        data_lock <= 0;
    end else if (valid_in) begin
        if (flag) begin
            // Second valid data received, concatenate and generate output
            valid_out <= 1;
            data_out <= {data_lock, data_in};
            flag <= 0;
        end else begin
            // First valid data received, store it and set flag
            data_lock <= data_in;
            flag <= 1;
            valid_out <= 0;
        end
    end else begin
        valid_out <= 0;
    end
end

endmodule