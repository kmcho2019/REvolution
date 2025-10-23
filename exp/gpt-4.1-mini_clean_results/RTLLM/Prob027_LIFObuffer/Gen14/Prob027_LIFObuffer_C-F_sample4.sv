module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,        // Active high reset
    input  wire        EN,         // Enable operations
    input  wire        RW,         // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: number of entries stored, ranges from 0 (empty) to 4 (full)
    reg [2:0] SP;

    // Define conditions for push and pop
    wire push_valid = (EN && (RW == 1'b0) && (SP < 3'd4));
    wire pop_valid  = (EN && (RW == 1'b1) && (SP > 3'd0));

    // Combinational flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Clear stack memory on reset
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            case ({push_valid, pop_valid})
                2'b10: begin
                    // Push operation
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 3'd1;
                    // dataOut unchanged on push to reduce toggling
                end
                2'b01: begin
                    // Pop operation
                    SP <= SP - 3'd1;
                    dataOut <= stack_mem[SP - 3'd1];
                    // Do NOT clear popped entry to reduce switching power
                end
                // No operation or both signals low: hold states
                default: begin
                    // Hold SP and dataOut
                    SP <= SP;
                    dataOut <= dataOut;
                end
            endcase
        end
    end

endmodule