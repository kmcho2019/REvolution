module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for storing 4 input values
    reg [7:0] data_reg [0:3];
    reg [1:0] wr_ptr;
    reg full_flag;

    // Combinational sum calculation
    wire [9:0] current_sum = data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
            wr_ptr <= 2'b0;
            full_flag <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;

            if (valid_in) begin
                // Store input data
                data_reg[wr_ptr] <= data_in;

                // Update write pointer and full flag
                if (wr_ptr == 2'b11) begin
                    wr_ptr <= 2'b0;
                    full_flag <= 1'b1;
                end
                else begin
                    wr_ptr <= wr_ptr + 1'b1;
                    full_flag <= 1'b0;
                end

                // Output results when buffer is full
                if (full_flag && (wr_ptr == 2'b11)) begin
                    data_out <= current_sum;
                    valid_out <= 1'b1;
                end
            end
        end
    end

endmodule