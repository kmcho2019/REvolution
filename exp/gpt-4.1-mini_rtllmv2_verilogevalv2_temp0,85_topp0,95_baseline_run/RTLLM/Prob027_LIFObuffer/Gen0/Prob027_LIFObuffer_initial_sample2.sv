module LIFObuffer(
    input wire [3:0] dataIn,
    input wire RW,  // 0: write(push), 1: read(pop)
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];  // 4 entries, 4-bit each
    reg [2:0] SP;  // stack pointer, range 0 to 4 (need 3 bits to represent 0-4)

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset: clear stack and initialize
                SP <= 3'd4;
                dataOut <= 4'd0;
                for (i = 0; i < 4; i = i + 1) begin
                    stack_mem[i] <= 4'd0;
                end
                EMPTY <= 1'b1;
                FULL <= 1'b0;
            end else begin
                // Default output if no read
                dataOut <= dataOut;

                if ((RW == 1'b0) && (SP != 0)) begin
                    // Write (push) if not full
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end else if ((RW == 1'b1) && (SP != 4)) begin
                    // Read (pop) if not empty
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end

                // Update flags
                EMPTY <= (SP == 4);
                FULL <= (SP == 0);
            end
        end
    end

endmodule