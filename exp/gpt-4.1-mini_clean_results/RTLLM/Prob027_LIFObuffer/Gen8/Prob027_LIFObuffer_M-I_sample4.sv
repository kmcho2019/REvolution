module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,     // active high reset
    input  wire       EN,      // enable
    input  wire       RW,      // 0 = write (push), 1 = read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries x 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: 3-bit unsigned, points to next free slot [0..4]
    // 0 means empty, 4 means full
    reg [2:0] SP;

    integer i;

    // Synchronous logic: push/pop and stack_mem update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;           // empty stack
            dataOut <= 4'd0;
            // Clear stack memory explicitly
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation (write)
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full: ignore push
            end else begin
                // Pop operation (read)
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
                // else empty: dataOut holds previous value
            end
        end
    end

    // Flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule