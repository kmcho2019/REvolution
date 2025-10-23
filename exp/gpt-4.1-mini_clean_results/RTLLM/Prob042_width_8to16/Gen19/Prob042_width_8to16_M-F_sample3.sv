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
            // Default: hold pipeline registers
            valid_out_pipe <= valid_out_pipe;
            data_out_pipe  <= data_out_pipe;

            if (valid_in) begin
                if (!first_data_valid) begin
                    // Store first input byte
                    first_data       <= data_in;
                    first_data_valid <= 1'b1;
                end else begin
                    // Second input byte arrived: concatenate and assert valid_out in next cycle
                    data_out_pipe    <= {first_data, data_in};
                    valid_out_pipe   <= 1'b1;
                    first_data_valid <= 1'b0;
                end
            end else begin
                // When no valid_in, hold stored first data and pipeline outputs
                // Also clear valid_out_pipe after one cycle to de-assert valid_out correctly
                if (valid_out_pipe) begin
                    valid_out_pipe <= 1'b0;  // Clear valid after one cycle asserted
                end
            end

            // Register outputs with one cycle delay from pipeline registers
            data_out  <= data_out_pipe;
            valid_out <= valid_out_pipe;
        end
    end

endmodule