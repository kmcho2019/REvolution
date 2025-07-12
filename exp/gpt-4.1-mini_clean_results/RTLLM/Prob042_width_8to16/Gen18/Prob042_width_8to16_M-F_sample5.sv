module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  first_data;        // Stores first 8-bit input
    reg        first_data_valid;  // Indicates first_data is valid

    reg [15:0] data_out_pipe;     // Pipeline register holding concatenated data
    reg        valid_out_pipe;    // Pipeline register holding valid_out signal

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data       <= 8'd0;
            first_data_valid <= 1'b0;
            data_out_pipe    <= 16'd0;
            valid_out_pipe   <= 1'b0;
            data_out         <= 16'd0;
            valid_out        <= 1'b0;
        end else begin
            // Default: keep pipeline valid signal low unless updated
            valid_out_pipe <= 1'b0;

            if (valid_in) begin
                if (!first_data_valid) begin
                    // Store first incoming data byte and set flag
                    first_data       <= data_in;
                    first_data_valid <= 1'b1;
                end else begin
                    // Second valid_in: concatenate first and current data
                    data_out_pipe    <= {first_data, data_in};
                    valid_out_pipe   <= 1'b1;      // Assert valid_out in next cycle
                    first_data_valid <= 1'b0;      // Clear flag after forming output
                end
            end

            // Register the output data and valid signal with one cycle delay
            data_out  <= data_out_pipe;
            valid_out <= valid_out_pipe;
        end
    end

endmodule