module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Define the FIFO parameters
parameter FIFO_DEPTH = 4; // Adjust based on the specific requirements
parameter DATA_WIDTH = 4;

// FIFO implementation (simplified for illustration)
reg [DATA_WIDTH-1:0] fifo[FIFO_DEPTH-1:0];
reg [1:0] write_ptr;
reg [1:0] read_ptr;
reg full;
reg empty;

// Delayed enable signal (two clk_b cycles)
reg en_delay1;
reg en_delay2;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        write_ptr <= 2'd0;
        full <= 1'b0;
    end else if (data_en) begin
        // Write data into the FIFO
        if (!full) begin
            fifo[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            if (write_ptr == FIFO_DEPTH - 1) begin
                full <= 1'b1;
            end
        end
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        read_ptr <= 2'd0;
        empty <= 1'b1;
        en_delay1 <= 1'b0;
        en_delay2 <= 1'b0;
        dataout <= 4'd0;
    end else begin
        // Delay the enable signal by two clk_b cycles
        en_delay1 <= data_en;
        en_delay2 <= en_delay1;

        // Read data from the FIFO
        if (en_delay2 && !empty) begin
            dataout <= fifo[read_ptr];
            read_ptr <= read_ptr + 1;
            if (read_ptr == FIFO_DEPTH - 1) begin
                empty <= 1'b1;
            end
        end
    end
end

endmodule