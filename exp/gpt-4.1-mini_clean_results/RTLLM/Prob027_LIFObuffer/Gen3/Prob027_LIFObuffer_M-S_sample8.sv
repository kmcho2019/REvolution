module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output reg         EMPTY,
    output reg         FULL
);
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: 0..4 (number of valid entries)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            for (i=0; i<4; i=i+1)
                stack_mem[i] <= 4'b0;
            SP <= 3'd0;
            dataOut <= 4'b0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    stack_mem[SP - 1] <= 4'b0; // Optional clearing
                end
            end
            EMPTY <= (SP == 0);
            FULL  <= (SP == 4);
        end
    end
endmodule