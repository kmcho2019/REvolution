module LIFObuffer(
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];
    // Stack pointer: points to the next free position for push,
    // or top of stack for pop. Initialized to 4 = empty.
    reg [2:0] SP;

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset: clear stack, set SP to 4 (empty), clear dataOut
                SP <= 3'd4;
                dataOut <= 4'b0;
                for (i=0; i<4; i=i+1) begin
                    stack_mem[i] <= 4'b0;
                end
            end else begin
                // Update flags first based on current SP before operation
                EMPTY <= (SP == 3'd4);
                FULL <= (SP == 3'd0);

                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP != 3'd0) begin
                        SP <= SP - 3'd1;
                        stack_mem[SP - 3'd1] <= dataIn; // store at SP-1 position
                        EMPTY <= 1'b0; // definitely not empty now
                        if (SP - 3'd1 == 3'd0)
                            FULL <= 1'b1;
                        else
                            FULL <= 1'b0;
                    end
                    // No pop on write, dataOut unchanged
                end else begin
                    // Read operation (pop)
                    if (SP != 3'd4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'b0;
                        SP <= SP + 3'd1;
                        FULL <= 1'b0; // after pop cannot be full
                        if (SP + 3'd1 == 3'd4)
                            EMPTY <= 1'b1;
                        else
                            EMPTY <= 1'b0;
                    end else begin
                        // buffer empty, no pop, keep dataOut unchanged
                    end
                end
            end
        end
    end

endmodule