module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] buffered_data;      // Store first byte
    reg       has_first_byte;     // Flag: first byte stored
    reg [15:0] combined_data;     // Holds concatenated data after second byte
    reg       valid_out_reg;      // Registered valid signal delayed by 1 cycle after second byte

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffered_data  <= 8'd0;
            has_first_byte <= 1'b0;
            combined_data  <= 16'd0;
            valid_out_reg  <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            valid_out     <= valid_out_reg;
            data_out      <= combined_data;

            valid_out_reg <= 1'b0; // Default de-assert valid_out; assert only when ready

            if (valid_in) begin
                if (!has_first_byte) begin
                    // Store first byte
                    buffered_data  <= data_in;
                    has_first_byte <= 1'b1;
                end else begin
                    // Second byte arrived: concatenate and prepare output for next cycle
                    combined_data  <= {buffered_data, data_in};
                    has_first_byte <= 1'b0;    // Clear first byte flag after pair complete
                    valid_out_reg  <= 1'b1;    // Assert valid_out next cycle (registered here)
                end
            end
        end
    end

endmodule