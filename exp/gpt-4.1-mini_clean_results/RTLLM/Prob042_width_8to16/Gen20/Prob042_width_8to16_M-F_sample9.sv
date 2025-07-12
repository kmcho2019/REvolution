module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg        flag;       // Indicates first byte stored
    reg [7:0]  data_lock;  // Holds first byte

    reg        out_valid_reg;    // Registered valid for output (delayed by 1 cycle)
    reg [15:0] out_data_reg;    // Registered output data (delayed by 1 cycle)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag          <= 1'b0;
            data_lock     <= 8'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
            out_valid_reg <= 1'b0;
            out_data_reg  <= 16'd0;
        end else begin
            // Default: output valid cleared
            valid_out <= out_valid_reg;
            data_out  <= out_data_reg;

            out_valid_reg <= 1'b0;    // Default no output valid unless set below

            if (valid_in) begin
                if (!flag) begin
                    // First byte: store and set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second byte: capture concatenation for output next cycle
                    out_data_reg  <= {data_lock, data_in};
                    out_valid_reg <= 1'b1;
                    flag          <= 1'b0; // Reset flag for next pair
                end
            end
        end
    end

endmodule