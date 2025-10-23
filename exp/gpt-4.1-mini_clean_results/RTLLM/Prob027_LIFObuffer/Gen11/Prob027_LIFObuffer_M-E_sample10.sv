module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // active high reset
    input  wire        EN,        // enable
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack pointer: index of top element; -1 (empty) to 3 (full)
    reg signed [2:0] SP; // 3-bit signed for range -1..3

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= -1;              // empty stack
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 3) begin
                    SP <= SP + 1;
                    stack_mem[SP + 1] <= dataIn;
                end
                // else full, ignore push
            end else begin
                // Read (pop)
                if (SP >= 0) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0; // Optional clearing of popped data
                    SP <= SP - 1;
                end
                // else empty, hold dataOut
            end
        end
        // if EN=0, hold state
    end

    // Flags combinational
    assign EMPTY = (SP == -1);
    assign FULL  = (SP == 3);

endmodule