module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

// FIFO to store 4 data values
reg [7:0] fifo [3:0];
reg [1:0] fifo_ptr; // Pointer to the current FIFO position
reg fifo_full; // Flag indicating the FIFO is full

// Controller logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 0;
        fifo_full <= 0;
    end else if (valid_in) begin
        // Shift data into the FIFO
        fifo[fifo_ptr] <= data_in;
        fifo_ptr <= fifo_ptr + 1;
        if (fifo_ptr == 4) begin
            fifo_ptr <= 0; // Wrap around
            fifo_full <= 1;
        end
    end
end

// Sum calculation
reg [9:0] sum;
always @(posedge clk) begin
    if (fifo_full) begin
        sum <= fifo[0] + fifo[1] + fifo[2] + fifo[3];
    end
end

// Output logic
reg valid_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out_reg <= 0;
    end else if (fifo_full) begin
        valid_out_reg <= 1;
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule