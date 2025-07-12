module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;      // Stores first 8-bit data
    reg        has_data;       // Indicates if first data stored and waiting for second
    reg [15:0] out_reg;        // Holds concatenated output data before committing to output port
    reg        valid_stage2;   // Indicates output data in out_reg is valid (ready to be output next cycle)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock    <= 8'd0;
            has_data     <= 1'b0;
            out_reg      <= 16'd0;
            valid_stage2 <= 1'b0;
            data_out     <= 16'd0;
            valid_out    <= 1'b0;
        end else begin
            valid_out <= valid_stage2;     // Output valid from previous cycle's concatenation
            data_out  <= out_reg;          // Output data from previous cycle's concatenation

            valid_stage2 <= 1'b0;          // Default clear output valid stage2; will set if concat occurs now

            if (valid_in) begin
                if (!has_data) begin
                    // First valid input, store and wait for second
                    data_lock <= data_in;
                    has_data  <= 1'b1;
                end else begin
                    // Second valid input: concatenate and move to output stage register
                    out_reg      <= {data_lock, data_in};
                    valid_stage2 <= 1'b1;    // Indicate output valid next cycle
                    has_data     <= 1'b0;    // Clear flag after second input is processed
                end
            end
            // If no valid_in, maintain has_data flag and no update to out_reg or valid_stage2
        end
    end

endmodule