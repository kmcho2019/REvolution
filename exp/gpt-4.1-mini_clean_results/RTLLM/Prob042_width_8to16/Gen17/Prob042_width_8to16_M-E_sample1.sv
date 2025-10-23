module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] first_data;       // Holds the first incoming 8-bit data
    reg       first_data_valid; // Flag indicating first_data holds valid data

    // Pipeline registers for output delay
    reg [15:0] data_out_pipe;
    reg        valid_out_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data        <= 8'd0;
            first_data_valid  <= 1'b0;
            data_out_pipe     <= 16'd0;
            valid_out_pipe    <= 1'b0;
            data_out          <= 16'd0;
            valid_out         <= 1'b0;
        end else begin
            // Default deassert output valid signal each cycle
            valid_out_pipe <= 1'b0;

            if (valid_in) begin
                if (!first_data_valid) begin
                    // Store first 8-bit data and set flag
                    first_data       <= data_in;
                    first_data_valid <= 1'b1;
                end else begin
                    // Second valid_in: concatenate and prepare output pipeline
                    data_out_pipe   <= {first_data, data_in};
                    valid_out_pipe  <= 1'b1;
                    first_data_valid <= 1'b0; // Clear flag after second byte used
                end
            end

            // Transfer pipeline registers to output ports (delayed by one cycle)
            data_out  <= data_out_pipe;
            valid_out <= valid_out_pipe;
        end
    end

endmodule