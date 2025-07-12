module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output reg         EMPTY,
    output reg         FULL
);

    localparam DEPTH = 4;
    localparam PTR_WIDTH = 2; // 2 bits enough to count 0..4

    reg [3:0] stack_mem [0:DEPTH-1];
    reg [PTR_WIDTH:0] SP;       // stack pointer, counts 0..4
    reg [PTR_WIDTH:0] SP_next;  // next stack pointer value (combinational)

    integer i;

    // Combinational logic for next SP and memory write enable and address/data
    always @(*) begin
        SP_next = SP; // default: hold
        // Default: no memory update
        // In the sequential block, the actual write/read happens

        if (EN && !Rst) begin
            if (RW == 1'b0) begin // Push operation
                if (SP < DEPTH) begin
                    SP_next = SP + 1;
                end
            end else begin // Pop operation
                if (SP > 0) begin
                    SP_next = SP - 1;
                end
            end
        end
    end

    // Sequential logic: stack pointer and memory updates + reset
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            for (i = 0; i < DEPTH; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (EN) begin
                // Push
                if (RW == 1'b0 && SP < DEPTH) begin
                    stack_mem[SP] <= dataIn;
                end
                SP <= SP_next;

                // Update flags synchronously based on next SP
                EMPTY <= (SP_next == 0);
                FULL  <= (SP_next == DEPTH);
            end else begin
                // When EN is low, flags and SP remain unchanged
                EMPTY <= (SP == 0);
                FULL  <= (SP == DEPTH);
            end
        end
    end

    // dataOut update block: only on pop operation after SP changes
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'd0;
        end else if (EN && RW == 1'b1 && SP > 0) begin
            // Pop operation: output the data at stack_mem[SP-1]
            dataOut <= stack_mem[SP - 1];
            // Optional: clearing memory on pop not performed to reduce switching
        end
        // else retain previous dataOut
    end

endmodule