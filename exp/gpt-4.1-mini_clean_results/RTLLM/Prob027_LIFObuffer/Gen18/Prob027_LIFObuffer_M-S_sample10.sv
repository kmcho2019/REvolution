module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP): counts 0..4
    // SP = number of entries currently stored
    // 0 = empty, 4 = full
    reg [2:0] SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;        // empty
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin // Write (push)
                if (SP != 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 3'd1;
                end
            end else begin          // Read (pop)
                if (SP != 3'd0) begin
                    SP <= SP - 3'd1;
                    dataOut <= stack_mem[SP - 3'd1];
                end
            end
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule