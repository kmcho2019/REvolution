module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg       flag;             // Indicates if first byte is stored
    reg [7:0] data_lock;       // Stores first byte

    // Pipeline registers to hold output data and valid_out delayed by one cycle
    reg       valid_out_pipe;
    reg [15:0] data_out_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag           <= 1'b0;
            data_lock      <= 8'd0;

            data_out_pipe  <= 16'd0;
            valid_out_pipe <= 1'b0;

            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            // Output registers update with pipeline registers
            valid_out <= valid_out_pipe;
            data_out  <= data_out_pipe;

            valid_out_pipe <= 1'b0;    // Default no valid output
            data_out_pipe  <= 16'd0;   // Default clear output data when no valid output

            if (valid_in) begin
                if (!flag) begin
                    // Store first byte and set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // Second valid byte received: concatenate and prepare output next cycle
                    data_out_pipe  <= {data_lock, data_in};
                    valid_out_pipe <= 1'b1;
                    flag          <= 1'b0;  // Reset flag for next pair
                    data_lock     <= 8'd0;  // Optional clear to avoid stale data
                end
            end
        end
    end

endmodule