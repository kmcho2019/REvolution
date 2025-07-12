module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg [3:0]   dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries of 4-bit stack
    reg [2:0] SP;              // stack pointer, 0..4 (4 means empty)

    reg [2:0] next_SP;

    integer i;

    always @(*) begin
        // Default next_SP same as current
        next_SP = SP;

        if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP != 0) begin
                    next_SP = SP - 1;
                end
            end else begin
                // Read (pop)
                if (SP != 4) begin
                    next_SP = SP + 1;
                end
            end
        end
    end

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // Empty
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (EN) begin
                if (RW == 1'b0) begin
                    // Push operation
                    if (SP != 0) begin
                        SP <= next_SP;
                        stack_mem[next_SP] <= dataIn; // write at new SP
                    end else begin
                        SP <= SP; // no change if full
                    end
                end else begin
                    // Pop operation
                    if (SP != 4) begin
                        dataOut <= stack_mem[SP];
                        SP <= next_SP;
                        // No need to clear stack_mem on pop
                    end else begin
                        dataOut <= dataOut; // hold last value if empty
                        SP <= SP;           // no change
                    end
                end
            end else begin
                // No operation when EN=0
                SP <= SP;
                dataOut <= dataOut;
            end

            // Update flags based on updated SP
            EMPTY <= (next_SP == 4);
            FULL  <= (next_SP == 0);
        end
    end

endmodule