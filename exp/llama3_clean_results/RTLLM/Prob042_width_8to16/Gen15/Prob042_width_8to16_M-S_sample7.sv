module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_capture_reg;
reg valid_capture;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_capture_reg <= 8'b0;
        valid_capture <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (valid_capture) begin
                // Second valid data, assemble and output
                data_out <= {data_capture_reg, data_in};
                valid_out <= 1'b1;
                valid_capture <= 1'b0;
            end else begin
                // First valid data, capture
                data_capture_reg <= data_in;
                valid_capture <= 1'b1;
                valid_out <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule