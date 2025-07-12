module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  first_data;        // Store first 8-bit input
    reg        first_data_valid;  // Flag indicating first_data is valid

    reg [15:0] data_out_pipe;     // Pipeline register holding concatenated data (valid in current cycle)
    reg        valid_out_pipe;    // Pipeline register holding valid_out signal (valid in current cycle)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data       <= 8'd0;
            first_data_valid <= 1'b0;
            data_out_pipe    <= 16'd0;
            valid_out_pipe   <= 1'b0;
            data_out         <= 16'd0;
            valid_out        <= 1'b0;
        end else begin
            // Default: de-assert valid_out_pipe every cycle unless reasserted below
            valid_out_pipe <= 1'b0;

            if (valid_in) begin
                if (!first_data_valid) begin
                    // Capture first input byte
                    first_data       <= data_in;
                    first_data_valid <= 1'b1;
                end else begin
                    // Second input byte arrives: concatenate and generate output in next cycle
                    data_out_pipe    <= {first_data, data_in};
                    valid_out_pipe   <= 1'b1;
                    first_data_valid <= 1'b0;
                end
            end

            // Register output signals one cycle after pipeline registers
            data_out  <= data_out_pipe;
            valid_out <= valid_out_pipe;
        end
    end

endmodule