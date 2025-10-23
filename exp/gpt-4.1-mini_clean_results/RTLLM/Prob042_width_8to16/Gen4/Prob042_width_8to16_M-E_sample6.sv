module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [15:0] shift_reg;
    reg [1:0]  valid_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg   <= 16'd0;
            valid_count <= 2'd0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            valid_out <= 1'b0; // default no valid output

            if (valid_in) begin
                // Shift lower 8 bits to lower half, put new data_in in upper half
                shift_reg <= {data_in, shift_reg[7:0]};

                // Update valid count
                if (valid_count == 2'd1) begin
                    // Second valid input received: output next cycle
                    valid_out <= 1'b1;
                    data_out  <= {shift_reg[7:0], data_in};
                    valid_count <= 2'd0;
                end else begin
                    valid_count <= valid_count + 1'b1;
                end
            end
        end
    end

endmodule