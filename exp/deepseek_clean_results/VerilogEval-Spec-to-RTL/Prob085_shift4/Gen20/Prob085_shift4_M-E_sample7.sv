module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] buffer [0:3];  // 4-entry circular buffer
reg [1:0] head_ptr;      // Points to current MSB
reg [1:0] tail_ptr;      // Points to current LSB
reg empty;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset all buffer entries and pointers
        buffer[0] <= 1'b0;
        buffer[1] <= 1'b0;
        buffer[2] <= 1'b0;
        buffer[3] <= 1'b0;
        head_ptr <= 2'd0;
        tail_ptr <= 2'd3;
        empty <= 1'b1;
    end
    else if (load) begin
        // Load data into all positions
        buffer[0] <= data[0];
        buffer[1] <= data[1];
        buffer[2] <= data[2];
        buffer[3] <= data[3];
        head_ptr <= 2'd0;
        tail_ptr <= 2'd3;
        empty <= 1'b0;
    end
    else if (ena && !empty) begin
        // Shift operation - move tail pointer and clear new head
        tail_ptr <= tail_ptr - 1;
        buffer[head_ptr] <= 1'b0;
        head_ptr <= head_ptr + 1;
    end
end

// Output is always the concatenation of buffer contents in order
always @(*) begin
    q = {buffer[3], buffer[2], buffer[1], buffer[0]};
end

endmodule