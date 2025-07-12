module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output reg EMPTY, FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;
reg [3:0] temp;

always @ (posedge Clk) begin
    if (Rst) begin
        // Reset condition: Clear the stack and set SP to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b11; // 4 in binary is 100, but since we're using 2-bit SP, we use 11 to represent an empty buffer
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        // Check if buffer is full or empty
        if (~RW && (SP < 2'b11)) begin // Write operation and buffer is not full
            // Push data onto the stack
            stack_mem[SP] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && (SP < 2'b11)) begin // Read operation and buffer is not empty
            // Pop data from the stack
            temp <= stack_mem[SP + 1'b1];
            stack_mem[SP + 1'b1] <= 4'b0;
            SP <= SP + 1'b1;
            dataOut <= temp;
        end
        // Update EMPTY and FULL flags
        if (SP == 2'b11) begin
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (SP == 2'b00) begin
            EMPTY <= 1'b0;
            FULL <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
            FULL <= 1'b0;
        end
    end
end

endmodule