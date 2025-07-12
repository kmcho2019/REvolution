module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,      // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries, 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: number of elements currently in stack (0 to 4)
    reg [2:0] SP;

    // Flags for empty/full
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Internal signals for controlling memory write and read index
    reg write_en;
    reg [2:0] write_addr;
    reg [2:0] read_addr;
    reg pop_operation;

    // Sequential logic: Update Stack Pointer
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push
                if (!FULL)
                    SP <= SP + 1;
            end else begin
                // Pop
                if (!EMPTY)
                    SP <= SP - 1;
            end
        end
    end

    // Combinational logic: Determine write and read addresses and enables
    always @(*) begin
        write_en    = 1'b0;
        write_addr  = 3'd0;
        read_addr   = 3'd0;
        pop_operation = 1'b0;

        if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) if not full
                if (!FULL) begin
                    write_en   = 1'b1;
                    write_addr = SP; // Write at current SP (before increment)
                end
            end else begin
                // Read (pop) if not empty
                if (!EMPTY) begin
                    pop_operation = 1'b1;
                    read_addr = SP - 1; // Read from top element (SP - 1)
                end
            end
        end
    end

    // Synchronous write to stack memory
    always @(posedge Clk) begin
        if (Rst) begin
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (write_en) begin
            stack_mem[write_addr] <= dataIn;
        end
    end

    // Update dataOut on pop operation
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'd0;
        end else if (pop_operation) begin
            dataOut <= stack_mem[read_addr];
        end
        // else retain previous dataOut value
    end

endmodule