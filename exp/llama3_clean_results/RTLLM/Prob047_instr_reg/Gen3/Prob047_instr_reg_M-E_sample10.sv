module instr_reg(
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output [2:0] ins,
    output [4:0] ad1,
    output [7:0] ad2
);

// Define the FIFO parameters
parameter FIFO_DEPTH = 4;
parameter FIFO_WIDTH = 8;

// Define the FIFO signals
reg [FIFO_WIDTH-1:0] fifo[FIFO_DEPTH-1:0];
reg [FIFO_DEPTH-1:0] fifo_ptr;
reg [FIFO_DEPTH-1:0] fifo_cnt;

// Define the control unit signals
reg enqueue;
reg dequeue;

// Control unit logic
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        fifo_ptr <= 0;
        fifo_cnt <= 0;
    end else begin
        if (enqueue) begin
            if (fifo_cnt < FIFO_DEPTH) begin
                fifo[fifo_ptr] <= data;
                fifo_ptr <= fifo_ptr + 1;
                fifo_cnt <= fifo_cnt + 1;
            end
        end
        if (dequeue) begin
            if (fifo_cnt > 0) begin
                fifo_cnt <= fifo_cnt - 1;
                fifo_ptr <= fifo_ptr - 1;
            end
        end
    end
end

// FIFO read logic
always @(*) begin
    if (fifo_cnt > 0) begin
        ins <= fifo[0][7:5];
        ad1 <= fifo[0][4:0];
        ad2 <= fifo[1];
    end else begin
        ins <= 0;
        ad1 <= 0;
        ad2 <= 0;
    end
end

// Control unit inputs
assign enqueue = (fetch == 2'b01) || (fetch == 2'b10);
assign dequeue = (fetch == 2'b10);

endmodule