module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,      // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: points to next free position (0 to 4)

    // Combinational flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Pointer update logic
    reg [2:0] SP_next;
    always @(*) begin
        SP_next = SP;
        if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 3'd4)
                    SP_next = SP + 1;
            end else begin
                // Pop operation
                if (SP > 3'd0)
                    SP_next = SP - 1;
            end
        end
    end

    // Sequential pointer update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
        end else begin
            SP <= SP_next;
        end
    end

    // Memory write on push, synchronous read on pop
    always @(posedge Clk) begin
        if (Rst) begin
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
            dataOut <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push: write dataIn at current SP before increment
                if (!FULL) begin
                    stack_mem[SP] <= dataIn;
                    // dataOut unchanged on push
                end
            end else begin
                // Pop: read data from stack_mem at SP-1 after decrement
                if (!EMPTY) begin
                    dataOut <= stack_mem[SP_next];
                    // No memory clear on pop for power savings
                end
            end
        end
    end

endmodule