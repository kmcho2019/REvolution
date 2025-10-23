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

    reg [3:0] stack_mem [0:DEPTH-1];
    reg [2:0] SP; // 3 bits to count from 0 to 4 (max depth)

    // Asynchronous memory initialization (tool dependent)
    // This block ensures stack_mem starts at zero without reset cycle overhead
    // If synthesis tool doesn't support, replace with explicit reset clearing inside always block.
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            stack_mem[i] = 4'd0;
        end
    end

    assign EMPTY = (SP == 0);
    assign FULL  = (SP == DEPTH);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // stack_mem is already initialized asynchronously to zeros
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation if not full
                if (SP != DEPTH) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full: no operation
            end else begin
                // Read (pop) operation if not empty
                if (SP != 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Do not clear popped memory to save power
                end
                // else empty: no operation
            end
        end
        // else EN=0: hold state
    end

endmodule