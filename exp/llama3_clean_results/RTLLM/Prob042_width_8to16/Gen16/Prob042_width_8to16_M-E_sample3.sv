module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] fifo[1:0];
reg [1:0] fifo_ptr;
reg       fifo_empty;
reg       fifo_full;

assign valid_out = ~fifo_empty && fifo_ptr == 2'd2;
assign data_out = {fifo[1], fifo[0]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 2'd0;
        fifo[0] <= 8'd0;
        fifo[1] <= 8'd0;
        fifo_empty <= 1'b1;
        fifo_full <= 1'b0;
    end
    else begin
        // FIFO Operations
        if (valid_in && !fifo_full) begin
            if (fifo_ptr == 2'd0) begin
                fifo[0] <= data_in;
                fifo_ptr <= 2'd1;
            end
            else if (fifo_ptr == 2'd1) begin
                fifo[1] <= data_in;
                fifo_ptr <= 2'd2;
            end
        end
        
        // FIFO Status Update
        if (fifo_ptr == 2'd0) begin
            fifo_empty <= 1'b1;
            fifo_full <= 1'b0;
        end
        else if (fifo_ptr == 2'd2) begin
            fifo_empty <= 1'b0;
            fifo_full <= 1'b1;
        end
        else begin
            fifo_empty <= 1'b0;
            fifo_full <= 1'b0;
        end
        
        // Reset FIFO on Output
        if (valid_out) begin
            fifo_ptr <= 2'd0;
            fifo[0] <= 8'd0;
            fifo[1] <= 8'd0;
            fifo_empty <= 1'b1;
            fifo_full <= 1'b0;
        end
    end
end

endmodule