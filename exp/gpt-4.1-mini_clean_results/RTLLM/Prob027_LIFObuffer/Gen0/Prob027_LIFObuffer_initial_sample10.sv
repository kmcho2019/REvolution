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
    reg [2:0] SP; // Stack pointer from 0 to 4 (3 bits to hold value 4)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack memory to 0
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'b0000;
            end
            SP <= 3'd4;  // empty state, SP points beyond top element
            dataOut <= 4'b0000;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP-1] <= dataIn;
                end
            end else begin
                // Read operation (pop)
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0000;
                    SP <= SP + 1;
                end else begin
                    dataOut <= dataOut; // Hold dataOut when empty
                end
            end

            // Update flags based on new SP value
            EMPTY <= (SP == 4);
            FULL  <= (SP == 0);
        end
    end
endmodule