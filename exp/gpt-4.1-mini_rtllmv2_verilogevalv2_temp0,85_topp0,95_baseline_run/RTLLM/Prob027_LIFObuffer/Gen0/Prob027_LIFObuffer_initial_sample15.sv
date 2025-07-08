module LIFObuffer (
    input      [3:0] dataIn,
    input            RW,
    input            EN,
    input            Rst,
    input            Clk,
    output reg       EMPTY,
    output reg       FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries of 4 bits each
    reg [2:0] SP; // stack pointer, range 0 to 4; 4 means empty

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty
            dataOut <= 4'b0000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            // clear stack memory
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'b0000;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // write operation (push)
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    dataOut <= 4'b0000;
                end
            end else begin
                // read operation (pop)
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0000;
                    SP <= SP + 1;
                end else begin
                    dataOut <= 4'b0000;
                end
            end

            // update flags
            EMPTY <= (SP == 4);
            FULL  <= (SP == 0);
        end
    end

endmodule