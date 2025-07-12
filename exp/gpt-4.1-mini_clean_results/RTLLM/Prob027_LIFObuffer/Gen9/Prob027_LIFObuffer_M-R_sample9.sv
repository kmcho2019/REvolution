module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [0:3]; // 4 entries x 4 bits
    reg [2:0] SP;              // Stack pointer: number of elements (0-4)

    // EMPTY when no elements, FULL when 4 elements
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 4) begin
                    // Push dataIn at current SP position, then increment SP
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // dataOut unchanged on push
            end else begin
                // Read (pop)
                if (SP > 0) begin
                    // Decrement SP, output top data
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Clear popped location (optional)
                    stack_mem[SP - 1] <= 4'b0;
                end else begin
                    dataOut <= 4'b0; // Buffer empty, output zero
                end
            end
        end
    end

endmodule