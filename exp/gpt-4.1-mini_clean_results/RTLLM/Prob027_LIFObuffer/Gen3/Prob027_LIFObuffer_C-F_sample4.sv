module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write(push), 1: read(pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Points to next free slot (0 to 4)
    reg [2:0] pop_index; // Temporary index to hold SP-1 during pop

    integer i;

    // Combinational flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;            // Empty stack
            dataOut <= 4'd0;
            pop_index <= 3'd0;
            // Clear stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation (write)
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else: full, no operation
            end else begin
                // Pop operation (read)
                if (SP > 3'd0) begin
                    pop_index <= SP - 1;
                    SP <= SP - 1;
                end
                // else: empty, no operation
            end
        end
    end

    // Separate always block to update dataOut and clear popped memory, avoids timing hazards
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'd0;
        end else if (EN && RW == 1'b1) begin
            if (SP > 3'd0) begin
                // Update dataOut with the value from popped location (pop_index)
                dataOut <= stack_mem[pop_index];
                // Clear popped memory location to zero
                stack_mem[pop_index] <= 4'd0;
            end
            // else: do not change dataOut if empty
        end
    end

endmodule