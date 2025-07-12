module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock; // Register to store the first 8-bit data
reg flag; // Flag to track whether the first data has been stored

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset
        data_out <= 0;
        valid_out <= 0;
        data_lock <= 0;
        flag <= 0;
    end else if (valid_in &&!flag) begin // First valid data
        data_lock <= data_in;
        flag <= 1;
        valid_out <= 0;
    end else if (valid_in && flag) begin // Second valid data
        data_out <= {data_lock, data_in};
        valid_out <= 1;
        flag <= 0;
    end else begin
        valid_out <= 0;
    end
end

endmodule