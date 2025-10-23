module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg         data_lock;    // 1: first byte stored, 0: waiting for first byte
    reg [7:0]   first_byte;   // store first 8-bit input

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock  <= 1'b0;
            first_byte <= 8'd0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            valid_out <= 1'b0; // Default no valid output unless conditions met

            if (valid_in) begin
                if (!data_lock) begin
                    // Store first byte and set flag
                    first_byte <= data_in;
                    data_lock  <= 1'b1;
                end else begin
                    // Second byte arrives, output concatenated data next cycle
                    data_out  <= {first_byte, data_in};
                    valid_out <= 1'b1;
                    data_lock <= 1'b0; // Clear flag after output
                end
            end
        end
    end

endmodule