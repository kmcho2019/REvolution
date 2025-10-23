module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,         // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [0:3];
    reg [2:0] SP;  // Stack pointer: 0 means empty, 4 means full (max 4 entries)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            // Clear stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 3'd1;
                end
                // else ignore push if full
            end else begin
                // Read (pop) operation
                if (SP > 3'd0) begin
                    SP <= SP - 3'd1;
                    dataOut <= stack_mem[SP - 3'd1];
                    // Clear popped location for cleanliness (optional)
                    stack_mem[SP - 3'd1] <= 4'd0;
                end
                // else ignore pop if empty
            end

            // Update flags based on new SP value after operation
            EMPTY <= ( (RW == 1'b0 && SP == 3'd4) || (RW == 1'b1 && SP == 3'd0) ) ? 1'b1 : 1'b0;
            FULL  <= ( (RW == 1'b0 && SP == 3'd4) || (RW == 1'b1 && SP == 3'd0) ) ? 1'b0 : (SP == 3'd4);
            // But this can be simply:
            EMPTY <= (SP == 3'd0);
            FULL  <= (SP == 3'd4);
        end
    end

endmodule