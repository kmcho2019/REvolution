module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Counter to track the number of consecutive high cycles
reg [1:0] count;

// Previous value of data_in to detect rising and falling edges
reg prev_data_in;

// Gray code counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 2'b00; // Reset counter
        prev_data_in <= 0; // Reset previous data_in
        data_out <= 0; // Reset data_out
    end else begin
        // Update previous data_in
        prev_data_in <= data_in;

        // Check for rising edge of data_in
        if (data_in && !prev_data_in) begin
            // Start counting
            count <= 2'b01;
        end else if (data_in && prev_data_in) begin
            // Increment counter (using Gray code)
            case (count)
                2'b00: count <= 2'b01;
                2'b01: count <= 2'b11;
                2'b11: count <= 2'b10;
                2'b10: count <= 2'b00; // Wrap around after 2'b10
            endcase
        end else if (!data_in && prev_data_in) begin
            // Check if count indicates a pulse
            if (count == 2'b10) begin
                data_out <= 1; // Indicate pulse
            end else begin
                data_out <= 0; // Reset data_out
            end
            count <= 2'b00; // Reset counter
        end else begin
            // Reset counter and data_out if data_in is low
            count <= 2'b00;
            data_out <= 0;
        end
    end
end

endmodule