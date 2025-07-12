module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,        // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Number of elements in stack (0 to 4)

    wire push = (RW == 1'b0) && EN && (SP < 4);
    wire pop  = (RW == 1'b1) && EN && (SP > 0);

    // Stack pointer update: increment on push, decrement on pop
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
        end else begin
            case ({push, pop})
                2'b10: SP <= SP + 1;  // push only
                2'b01: SP <= SP - 1;  // pop only
                default: SP <= SP;    // no change or both asserted (should not happen)
            endcase
        end
    end

    // Memory write (push) and output data update (pop)
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else begin
            if (push) begin
                // Write new data at current SP position
                stack_mem[SP] <= dataIn;
                // dataOut unchanged on push
            end
            if (pop) begin
                // dataOut gets the element at SP-1 (top of stack)
                dataOut <= stack_mem[SP - 1];
                // Optionally clear popped location (not strictly needed)
                stack_mem[SP - 1] <= 4'd0;
            end
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule