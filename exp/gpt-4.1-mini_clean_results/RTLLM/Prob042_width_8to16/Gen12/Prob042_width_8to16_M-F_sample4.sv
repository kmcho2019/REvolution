module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output          valid_out,
    output [15:0]   data_out
);

    reg         data_lock;          // Flag: 1 when first byte stored, 0 otherwise
    reg [7:0]   first_byte;         // Store first byte

    reg         valid_out_reg;      // Output valid delayed by 1 cycle
    reg [15:0]  data_out_reg;       // Output data delayed by 1 cycle

    // Intermediate registers for output generation in current cycle
    reg         out_valid_next;
    reg [15:0]  out_data_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 1'b0;
            first_byte     <= 8'd0;
            valid_out_reg  <= 1'b0;
            data_out_reg   <= 16'd0;
        end else begin
            // Default outputs cleared
            out_valid_next <= 1'b0;
            out_data_next  <= 16'd0;

            if (valid_in) begin
                if (!data_lock) begin
                    // Store first byte and set flag
                    first_byte <= data_in;
                    data_lock  <= 1'b1;
                    // No output yet
                    out_valid_next <= 1'b0;
                end else begin
                    // Second byte arrived, output concatenated data next cycle
                    out_data_next  <= {first_byte, data_in};
                    out_valid_next <= 1'b1;
                    data_lock      <= 1'b0;  // Reset flag for next pair
                end
            end

            // Update output registers with next cycle's output
            valid_out_reg <= out_valid_next;
            data_out_reg  <= out_data_next;
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule