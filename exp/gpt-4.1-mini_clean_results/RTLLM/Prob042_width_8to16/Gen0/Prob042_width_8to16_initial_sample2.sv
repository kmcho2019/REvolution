module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg flag; // Indicates if first data is stored

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'd0;
            flag <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 16'd0;
        end else begin
            valid_out <= 1'b0; // Default to 0, assert only when output valid

            if (valid_in) begin
                if (flag) begin
                    // We already have first data locked, now output concatenated data
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    flag <= 1'b0; // Clear flag after output
                end else begin
                    // Store first valid data and set flag
                    data_lock <= data_in;
                    flag <= 1'b1;
                end
            end
        end
    end

endmodule