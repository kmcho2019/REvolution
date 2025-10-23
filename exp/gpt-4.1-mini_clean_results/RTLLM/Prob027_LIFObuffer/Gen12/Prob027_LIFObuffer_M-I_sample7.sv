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
    reg [2:0] SP; // Number of elements in stack (0 to 4)
    reg [1:0] pop_addr; // Registered address for pop read

    wire push_en = EN & (RW == 1'b0) & (SP < 4);
    wire pop_en  = EN & (RW == 1'b1) & (SP > 0);

    // On pop, pre-decrement SP and store pop address to read stack_mem synchronously next cycle
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            pop_addr <= 2'd0;
            dataOut <= 4'd0;
            // stack_mem content left unchanged for power savings
        end else begin
            if (push_en) begin
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
                // dataOut unchanged on push
            end else if (pop_en) begin
                SP <= SP - 1;
                pop_addr <= SP - 1; // store address to read next cycle
            end

            // Update dataOut synchronously from stack_mem using pop_addr, but only when pop_en was asserted last cycle
            // To know that, we track pop_en in a register to sync read latency.
        end
    end

    // To output the popped data one cycle after pop_en, register pop_en signal
    reg pop_en_d;

    always @(posedge Clk) begin
        if (Rst) begin
            pop_en_d <= 1'b0;
            dataOut <= 4'd0;
        end else begin
            pop_en_d <= pop_en;
            if (pop_en_d) begin
                dataOut <= stack_mem[pop_addr];
            end
            // else retain dataOut
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule