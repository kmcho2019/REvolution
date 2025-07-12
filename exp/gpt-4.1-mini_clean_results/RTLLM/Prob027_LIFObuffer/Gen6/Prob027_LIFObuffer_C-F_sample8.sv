module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    localparam DEPTH = 4;
    localparam PTR_WIDTH = 2; // 2 bits to count 0..4

    reg [3:0] stack_mem [0:DEPTH-1];
    reg [PTR_WIDTH:0] SP; // 0 to DEPTH, 3 bits to count 0..4

    integer i;

    // Flags
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == DEPTH);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'd0;
            // Clear stack memory on reset
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
                // dataOut unchanged on push
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Optional: clear popped memory location to reduce glitching/power,
                    // but often omitted for power savings
                end
                // else empty: dataOut retains last value
            end
        end
        // else EN=0: no operation, state retained
    end

endmodule