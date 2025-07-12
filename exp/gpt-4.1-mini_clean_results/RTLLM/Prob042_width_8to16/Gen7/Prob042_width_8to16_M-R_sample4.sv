module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg          flag;          // Indicates that first data byte is latched
    reg  [7:0]   data_lock;    // Stores first 8-bit input
    reg  [15:0]  data_out_reg; // Holds concatenated output data
    reg          valid_out_reg;// Delayed valid signal for output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag          <= 1'b0;
            data_lock     <= 8'd0;
            data_out_reg  <= 16'd0;
            valid_out_reg <= 1'b0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0;  // Default no output valid this cycle

            if (valid_in) begin
                if (!flag) begin
                    // First valid input: store in data_lock and set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second valid input: concatenate and prepare output
                    data_out_reg  <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    flag          <= 1'b0;  // Clear flag for next pair
                end
            end

            // Output valid and data generated one cycle after second input
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule