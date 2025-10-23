module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

// Stack memory array
reg [3:0] stack_mem [0:3];
// Counter to keep track of the number of elements in the buffer
reg [1:0] count;

// Initialize counter and stack pointer on reset
always @(posedge Clk) begin
    if (Rst) begin
        count <= 2'd0; // Initialize counter to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // Initialize stack memory to 0
        end
    end else if (EN) begin
        if (!RW && count < 2'd4) begin // Write operation and buffer is not full
            stack_mem[count] <= dataIn;
            count <= count + 1;
        end else if (RW && count > 2'd0) begin // Read operation and buffer is not empty
            dataOut <= stack_mem[count - 1];
            stack_mem[count - 1] <= 4'd0;
            count <= count - 1;
        end
    end
end

// Continuously update EMPTY and FULL flags based on counter
assign EMPTY = (count == 2'd0);
assign FULL = (count == 2'd4);

endmodule