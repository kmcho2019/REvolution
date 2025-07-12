module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,        // Active high synchronous reset
    input  wire        EN,         // Enable for operations
    input  wire        RW,         // Read/Write control: 0 = push (write), 1 = pop (read)
    input  wire [3:0]  dataIn,     // Data input for push
    output wire        EMPTY,      // High when buffer is empty
    output wire        FULL,       // High when buffer is full
    output reg  [3:0]  dataOut     // Data output for pop
);

    // Stack memory: 4 entries, each 4-bit wide
    reg [3:0] stack_mem [3:0];

    // Stack pointer SP:
    // Range: 0..4
    // SP == 0 means empty (no data)
    // SP == 4 means full (4 entries filled)
    reg [2:0] SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;          // Empty
            dataOut <= 4'd0;
            for (i=0; i<4; i=i+1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin // Push operation
                if (SP != 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 3'd1;
                end
            end else begin          // Pop operation
                if (SP != 3'd0) begin
                    SP <= SP - 3'd1;
                    dataOut <= stack_mem[SP - 3'd1];
                end
            end
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule