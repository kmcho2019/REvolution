module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg [3:0]   dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];
    // Stack Pointer (SP): points to next free position. 
    // SP = 4 means empty; SP = 0 means full.
    reg [2:0] SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty
            dataOut <= 4'b0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for(i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'b0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP > 0) begin
                    SP <= SP - 1;
                    stack_mem[SP-1] <= dataIn; // decrement then write
                    EMPTY <= 1'b0;
                    if (SP - 1 == 0)
                        FULL <= 1'b1;
                    else
                        FULL <= 1'b0;
                end
                // If full, ignore write
            end else begin
                // Read operation (pop)
                if (SP < 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1;
                    FULL <= 1'b0;
                    if (SP + 1 == 4)
                        EMPTY <= 1'b1;
                    else
                        EMPTY <= 1'b0;
                end else begin
                    // If empty, dataOut holds last value or 0
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule