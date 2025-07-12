module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock; // Temporary storage for the first 8-bit data
reg flag; // Flag signal to track the arrival of the first 8-bit data

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset
        data_out <= 16'd0;
        data_lock <= 8'd0;
        flag <= 1'b0;
        valid_out <= 1'b0;
    end else if (valid_in) begin // Valid input data
        if (!flag) begin // First 8-bit data arrival
            data_lock <= data_in;
            flag <= 1'b1;
            valid_out <= 1'b0;
        end else begin // Second 8-bit data arrival
            data_out <= {data_lock, data_in}; // Concatenate data
            valid_out <= 1'b1;
            flag <= 1'b0;
        end
    end else begin // Invalid input data
        valid_out <= 1'b0;
    end
end

endmodule