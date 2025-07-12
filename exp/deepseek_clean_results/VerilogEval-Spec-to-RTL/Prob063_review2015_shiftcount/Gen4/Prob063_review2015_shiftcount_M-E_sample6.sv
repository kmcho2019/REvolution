module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Circular buffer implementation
reg [3:0] buffer [0:3];
reg [1:0] head_ptr = 0;
reg [1:0] tail_ptr = 0;

// Operation tracking
reg op_shift, op_count;
reg op_data;

// Pipeline stages
reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(posedge clk) begin
    // Stage 1: Capture operation
    op_shift <= shift_ena;
    op_count <= count_ena;
    op_data <= data;
    
    // Stage 2: Perform operation
    if (op_shift) begin
        // Shift operation - rotate buffer and insert new data
        buffer[head_ptr] <= op_data;
        head_ptr <= head_ptr + 1;
        tail_ptr <= tail_ptr + 1;
        stage2_out <= {buffer[(head_ptr+3)%4], buffer[(head_ptr+2)%4], 
                      buffer[(head_ptr+1)%4], buffer[head_ptr]};
    end
    else if (op_count) begin
        // Count operation - decrement current value
        stage2_out <= {buffer[tail_ptr], buffer[(tail_ptr+1)%4], 
                      buffer[(tail_ptr+2)%4], buffer[(tail_ptr+3)%4]} - 1'b1;
    end
    
    // Stage 3: Update output
    q <= stage2_out;
    
    // Update circular buffer after count operation
    if (op_count) begin
        buffer[tail_ptr] <= stage2_out[3];
        buffer[(tail_ptr+1)%4] <= stage2_out[2];
        buffer[(tail_ptr+2)%4] <= stage2_out[1];
        buffer[(tail_ptr+3)%4] <= stage2_out[0];
    end
end

// Initialize buffer
initial begin
    buffer[0] = 0;
    buffer[1] = 0;
    buffer[2] = 0;
    buffer[3] = 0;
end

endmodule