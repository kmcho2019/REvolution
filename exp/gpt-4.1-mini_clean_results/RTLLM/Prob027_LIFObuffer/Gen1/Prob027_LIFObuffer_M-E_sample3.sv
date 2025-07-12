module LIFObuffer (
    input       [3:0] dataIn,
    input             RW,    // 0: write(push), 1: read(pop)
    input             EN,
    input             Rst,
    input             Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // stack pointer: 3'b111 (-1) means empty, 0..3 valid indices

    integer i;

    // Parameters for special values
    localparam SP_EMPTY = 3'b111; // -1 in 3-bit unsigned

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset all
                SP <= SP_EMPTY;
                dataOut <= 4'b0;
                EMPTY <= 1'b1;
                FULL <= 1'b0;
                for (i=0; i<4; i=i+1) begin
                    stack_mem[i] <= 4'b0;
                end
            end else begin
                if (RW == 1'b0) begin
                    // Write (push)
                    if (SP != 3'd3) begin // not full
                        SP <= SP + 3'd1;
                        stack_mem[SP + 3'd1] <= dataIn; // Write data at new top
                        dataOut <= dataOut; // retain previous output
                    end else begin
                        dataOut <= dataOut; // no change if full
                    end
                end else begin
                    // Read (pop)
                    if (SP != SP_EMPTY) begin // not empty
                        dataOut <= stack_mem[SP]; // read top
                        stack_mem[SP] <= 4'b0;    // clear popped data
                        SP <= SP - 3'd1;          // decrement SP
                    end else begin
                        dataOut <= dataOut; // no change if empty
                    end
                end

                // Update EMPTY and FULL flags
                EMPTY <= (SP == SP_EMPTY);
                FULL  <= (SP == 3'd3);
            end
        end
    end

endmodule