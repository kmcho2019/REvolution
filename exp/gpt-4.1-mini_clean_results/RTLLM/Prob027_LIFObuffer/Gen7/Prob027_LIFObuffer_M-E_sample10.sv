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

    localparam DEPTH = 4;
    localparam PTR_WIDTH = 3; // 3 bits to represent -1 (empty) through 3

    // Stack memory
    reg [3:0] stack_mem [0:DEPTH-1];
    reg [PTR_WIDTH-1:0] SP; // Stack pointer: -1 (3'b111) when empty, 0..3 valid indices

    integer i;

    // Define the empty pointer as 3'b111 (7 decimal) to represent -1
    localparam [PTR_WIDTH-1:0] EMPTY_PTR = 3'b111;

    // Flags
    assign EMPTY = (SP == EMPTY_PTR);
    assign FULL  = (SP == (DEPTH-1));

    // Synchronous reset and operations
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack pointer to empty state
            SP <= EMPTY_PTR;
            dataOut <= 4'd0;
            // Clear stack memory
            for (i = 0; i < DEPTH; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (!FULL) begin
                    // Increment SP (top element pointer)
                    if (SP == EMPTY_PTR) begin
                        SP <= 0;
                        stack_mem[0] <= dataIn;
                    end else begin
                        SP <= SP + 1;
                        stack_mem[SP + 1] <= dataIn;
                    end
                end
                // else full: do nothing
            end else begin
                // Read (pop)
                if (!EMPTY) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    if (SP == 0) begin
                        SP <= EMPTY_PTR;
                    end else begin
                        SP <= SP - 1;
                    end
                end
                // else empty: dataOut holds previous value
            end
        end
        // else EN=0: hold current state
    end

endmodule