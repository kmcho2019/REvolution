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
    reg [2:0] SP; // Stack pointer ranges 0..4, where 4 means empty

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack memory to 0
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'b0000;
            end
            SP <= 3'd4;  // Empty stack indicated by SP=4
            dataOut <= 4'b0000;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
        end else if (EN) begin
            reg [2:0] next_SP;
            reg [3:0] next_dataOut;

            next_SP = SP;
            next_dataOut = dataOut;

            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP != 0) begin
                    // Decrement SP first, then write data
                    next_SP = SP - 1;
                    stack_mem[next_SP] <= dataIn;
                end
                // On write, dataOut holds previous value
                // Flags updated below
            end else begin
                // Read operation (pop)
                if (SP != 4) begin
                    // Read current top data before incrementing SP
                    next_dataOut = stack_mem[SP];
                    // Clear popped location
                    stack_mem[SP] <= 4'b0000;
                    next_SP = SP + 1;
                end
                // If empty, hold dataOut
            end

            // Update SP and dataOut at end of always block
            SP <= next_SP;
            dataOut <= next_dataOut;

            // Update flags based on next_SP value
            EMPTY <= (next_SP == 4);
            FULL  <= (next_SP == 0);
        end
    end
endmodule