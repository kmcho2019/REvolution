module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [0:3];

    // Stack pointer (SP): 0..4
    // SP=0 means empty, SP=4 means full
    reg [2:0] SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;          // empty
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin // write (push)
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 3'd1;
                end
            end else begin        // read (pop)
                if (SP > 3'd0) begin
                    SP <= SP - 3'd1;
                    dataOut <= stack_mem[SP - 3'd1];
                    // Do not clear stack_mem[SP-1] to save power
                end
            end
        end
        // else hold current state
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule