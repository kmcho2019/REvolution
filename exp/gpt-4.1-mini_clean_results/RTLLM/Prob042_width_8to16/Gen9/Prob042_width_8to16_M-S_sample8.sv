module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;
    reg        has_data;

    // Registered outputs (delayed by one cycle after second input)
    reg        valid_out_reg;
    reg [15:0] data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            has_data      <= 1'b0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0;  // Default no valid output each cycle

            if (valid_in) begin
                if (!has_data) begin
                    // Store first 8-bit input
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // Second input: prepare concatenated output next cycle
                    data_out_reg  <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    has_data     <= 1'b0;
                end
            end

            // Register outputs one cycle after second valid input
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule