module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

// FIFO Buffer
reg [7:0] fifo_buf [0:3];
reg [1:0] fifo_ptr;

// Valid Signal Generator
reg valid_out_reg;

// Accumulator
reg [9:0] sum_reg;

// Reset and Control Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 0;
        valid_out_reg <= 0;
        sum_reg <= 0;
    end else begin
        // FIFO Buffer Operations
        if (valid_in) begin
            fifo_buf[fifo_ptr] <= data_in;
            if (fifo_ptr == 3) begin
                fifo_ptr <= 0;
            end else begin
                fifo_ptr <= fifo_ptr + 1;
            end
        end

        // Valid Signal Generator
        if (fifo_ptr == 0) begin
            valid_out_reg <= 1;
        end else begin
            valid_out_reg <= 0;
        end

        // Accumulator
        if (valid_out_reg) begin
            sum_reg <= fifo_buf[0] + fifo_buf[1] + fifo_buf[2] + fifo_buf[3];
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum_reg;

endmodule