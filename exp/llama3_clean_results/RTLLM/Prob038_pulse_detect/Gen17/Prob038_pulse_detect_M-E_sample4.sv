module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] counter; // Counter to track the number of cycles data_in is high

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        counter <= 2'b00; // Reset counter
        data_out <= 1'b0; // Reset output
    end else begin
        if (data_in) begin // data_in is high
            counter <= counter + 1; // Increment counter
            if (counter == 2'b11) begin // Counter reaches threshold (3 cycles)
                data_out <= 1'b1; // Set output high
            end else begin
                data_out <= 1'b0; // Output remains low
            end
        end else begin // data_in is low
            if (counter == 2'b11) begin // Counter reached threshold in previous cycle
                data_out <= 1'b1; // Set output high
            end else begin
                data_out <= 1'b0; // Output remains low
            end
            counter <= 2'b00; // Reset counter
        end
    end
end

always @(posedge clk) begin
    if (counter == 2'b11) begin // Counter reached threshold
        data_out <= 1'b0; // Reset output after one cycle
    end
end

endmodule