module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

// FIFO implementation
reg [7:0] fifo [1:0]; // Simple 2-depth FIFO
reg [1:0] fifo_cnt; // Counter to track number of elements in FIFO

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_cnt <= 2'b00;
        valid_out <= 1'b0;
        data_out <= 16'd0;
        fifo[0] <= 8'd0;
        fifo[1] <= 8'd0;
    end
    else begin
        if (valid_in) begin
            // Enqueue data into FIFO
            if (fifo_cnt == 2'b00) begin
                fifo[0] <= data_in;
                fifo_cnt <= 2'b01;
            end
            else if (fifo_cnt == 2'b01) begin
                fifo[1] <= data_in;
                fifo_cnt <= 2'b11;
            end
        end
        
        // Dequeue and generate output if FIFO has at least two elements
        if (fifo_cnt == 2'b11) begin
            data_out <= {fifo[0], fifo[1]};
            valid_out <= 1'b1;
            fifo_cnt <= 2'b00; // Reset FIFO counter
        end
        else begin
            valid_out <= 1'b0; // Reset valid_out if FIFO doesn't have enough elements
        end
    end
end

endmodule