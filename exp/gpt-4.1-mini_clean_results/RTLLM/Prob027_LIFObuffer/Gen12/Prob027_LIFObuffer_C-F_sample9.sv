module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4 bits each
    reg [3:0] stack_mem [3:0];
    // Stack Pointer: number of elements currently in the stack (0..4)
    reg [2:0] SP;

    // Signals for valid operations
    wire push_valid = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_valid  = EN && (RW == 1'b1) && (SP > 3'd0);
    wire valid_op   = push_valid || pop_valid;

    integer i;

    // EMPTY when SP==0, FULL when SP==4
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Clear all stack memory locations on reset
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (valid_op) begin
            if (push_valid) begin
                stack_mem[SP] <= dataIn; // Push data at current SP index
                SP <= SP + 3'd1;
                // dataOut unchanged on push
            end else if (pop_valid) begin
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1]; // Pop data from top
                // Do not clear stack_mem location to save power
            end
        end
        // If no valid_op, maintain current SP and dataOut
    end

endmodule