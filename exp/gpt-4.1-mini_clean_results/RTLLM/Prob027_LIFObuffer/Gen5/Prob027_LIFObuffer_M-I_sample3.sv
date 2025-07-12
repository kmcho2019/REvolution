module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Parameters
    localparam DEPTH = 4;
    localparam PTR_WIDTH = 2; // log2(4) = 2 bits

    // Stack memory and pointer
    reg [3:0] stack_mem [0:DEPTH-1];
    reg [PTR_WIDTH-1:0] SP; // Points to next free location (0 when empty)

    integer i;

    // Assign flags based on SP
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == DEPTH);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'd0;
            // Clear stack memory in one loop
            for (i = 0; i < DEPTH; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < DEPTH) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // If full, do nothing
                // dataOut retains previous value
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Do not clear popped memory to reduce switching
                end
                // If empty, no operation and dataOut retains value
            end
        end
        // If EN=0, no operation and dataOut retains value
    end

endmodule