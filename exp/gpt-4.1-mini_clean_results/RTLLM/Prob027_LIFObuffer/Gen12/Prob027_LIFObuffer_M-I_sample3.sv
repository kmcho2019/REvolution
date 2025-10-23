module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,      // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output reg        EMPTY,
    output reg        FULL
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Number of elements in stack (0 to 4)
    reg [3:0] temp_data;
    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
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
                    temp_data <= stack_mem[SP - 1];   // Read before decrement
                    stack_mem[SP - 1] <= 4'd0;       // Clear popped element
                    SP <= SP - 1;
                    dataOut <= temp_data;
                end
            end

            // Update flags synchronously to avoid glitches
            EMPTY <= (SP == 0);
            FULL  <= (SP == 4);
        end else begin
            // Hold outputs and flags when EN is low
            EMPTY <= EMPTY;
            FULL  <= FULL;
            dataOut <= dataOut;
        end
    end

endmodule