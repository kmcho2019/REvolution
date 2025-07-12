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

reg [3:0] stack_mem [3:0]; // 4-entry stack memory array
reg [1:0] SP; // Stack pointer (0-3)
reg [3:0] temp_data; // Temporary data for pop operation

always @(posedge Clk) begin
    if (Rst) begin
        // Reset operation: clear stack, set SP to 4 (empty), and initialize memory to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4; // Set SP to 4 to indicate an empty buffer
        EMPTY <= 1'b1; // Buffer is empty after reset
        FULL <= 1'b0; // Buffer is not full after reset
    end else if (EN) begin
        if (RW == 0 && SP > 0) begin // Write operation (push)
            // Push data onto the stack and decrement SP
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
            if (SP == 0) begin
                FULL <= 1'b1; // Buffer is full
            end
            EMPTY <= 1'b0; // Buffer is not empty after push
        end else if (RW == 1 && SP < 4) begin // Read operation (pop)
            // Pop data from the stack into temp_data and increment SP
            temp_data <= stack_mem[SP];
            SP <= SP + 1;
            if (SP == 4) begin
                EMPTY <= 1'b1; // Buffer is empty
            end
            FULL <= 1'b0; // Buffer is not full after pop
        end
    end
end

always @(*) begin
    // Assign dataOut with the popped data
    if (RW == 1 && SP < 4) begin
        dataOut = temp_data;
    end else begin
        dataOut = 4'd0; // Default output when not popping
    end
end

endmodule