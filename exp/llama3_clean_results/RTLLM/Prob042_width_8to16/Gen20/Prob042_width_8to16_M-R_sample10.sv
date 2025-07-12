module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] first_data;
reg waiting_for_second;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        first_data <= 8'b0;
        waiting_for_second <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0; // Default to invalid
        if (valid_in) begin
            if (!waiting_for_second) begin
                // Capture first data and transition to waiting state
                first_data <= data_in;
                waiting_for_second <= 1'b1;
            end else begin
                // Second data captured, generate output and reset state
                data_out <= {first_data, data_in};
                valid_out <= 1'b1; // Indicate valid output
                waiting_for_second <= 1'b0;
            end
        end
    end
end

endmodule