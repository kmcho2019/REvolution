module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] high_count; // Counter for consecutive high cycles
reg [1:0] prev_data_in; // Register to store previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        high_count <= 0; // Reset high count
        prev_data_in <= 0; // Reset previous data_in value
        data_out <= 0; // Reset output
    end else begin
        if (data_in) begin
            if (prev_data_in) begin
                high_count <= high_count + 1; // Increment high count if data_in remains high
            end else begin
                high_count <= 1; // Reset high count and set to 1 if data_in transitions from low to high
            end
        end else begin
            if (prev_data_in) begin
                if (high_count == 1) begin
                    data_out <= 1; // Set output to 1 if pulse is detected
                end else begin
                    data_out <= 0; // Reset output if no pulse is detected
                end
                high_count <= 0; // Reset high count if data_in transitions from high to low
            end else begin
                data_out <= 0; // Reset output if data_in remains low
            end
        end
        prev_data_in <= data_in; // Update previous data_in value
    end
end

endmodule