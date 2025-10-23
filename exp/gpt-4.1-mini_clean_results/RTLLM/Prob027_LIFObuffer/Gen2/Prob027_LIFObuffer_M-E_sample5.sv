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
    reg [2:0] SP;              // stack pointer: points to next free slot (0 to 4)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all stack memory and pointer
            SP <= 3'd0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full - do nothing
            end else begin
                // Read (pop)
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Optionally clear popped location:
                    // stack_mem[SP - 1] <= 4'd0;
                end
                // else empty - no change
            end

            // Update flags based on new SP
            EMPTY <= (SP == 0);
            FULL  <= (SP == 4);
        end
    end

endmodule