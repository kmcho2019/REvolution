module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] stored_data;
reg waiting_second;

always @(posedge clk) begin
    if (!rst_n) begin
        stored_data <= 8'b0;
        waiting_second <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (waiting_second) begin
                // Second byte arrived - output concatenated data
                data_out <= {stored_data, data_in};
                valid_out <= 1'b1;
                waiting_second <= 1'b0;
            end else begin
                // First byte - store it and wait for second
                stored_data <= data_in;
                waiting_second <= 1'b1;
                valid_out <= 1'b0;  // Explicitly clear when storing first byte
            end
        end else begin
            valid_out <= 1'b0;  // Clear when no valid input
        end
    end
end

endmodule