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

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
        data_lock <= 0;
        flag <= 0;
        valid_out <= 0;
    end else if (valid_in && !flag) begin
        // Store the first valid data
        data_lock <= data_in;
        flag <= 1;
        valid_out <= 0;
    end else if (valid_in && flag) begin
        // Concatenate and output the data
        data_out <= {data_lock, data_in};
        valid_out <= 1;
        flag <= 0;
    end else begin
        valid_out <= 0;
    end
end

endmodule