module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg       flag;          // Indicates first byte is stored
    reg [7:0] data_lock;    // Stores first byte

    // Registers for output staging
    reg       valid_out_reg;
    reg [15:0] data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag          <= 1'b0;
            data_lock     <= 8'd0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0; // default de-assert output valid stage

            if (valid_in) begin
                if (!flag) begin
                    // Store first byte, no output yet
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second byte received, prepare output next cycle
                    data_out_reg  <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    flag         <= 1'b0;  // reset flag to store next first byte
                end
            end

            // Output stage: assert valid_out and data_out delayed by one cycle
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule