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

    reg [3:0] stack_mem [0:3]; // 4x4-bit stack memory
    reg [2:0] SP;              // stack pointer: points to next free location (0 to 4)

    // Flags combinational
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Initialize stack pointer to empty state
            SP <= 3'd4;
            dataOut <= 4'd0;
            // Clear stack memory entries
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (!FULL) begin
                    // SP decremented first, then write data
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    // dataOut unchanged on push
                end
            end else begin
                // Read (pop) operation
                if (!EMPTY) begin
                    dataOut <= stack_mem[SP];
                    // Clear popped element (optional)
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end else begin
                    dataOut <= 4'd0;
                end
            end
        end
    end

endmodule