module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [1:0] SP;         // Stack Pointer: points to current top (0 to 3)
    reg [2:0] count;      // Number of valid entries in stack (0 to 4)

    integer i;

    // On reset, clear stack, reset pointers and flags
    always @(posedge Clk) begin
        if (Rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
            SP <= 2'd0;
            count <= 3'd0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write operation (push)
                if (count < 4) begin
                    // Increment SP with wrap-around
                    SP <= (SP == 2'd3) ? 2'd0 : SP + 1'b1;
                    stack_mem[(SP == 2'd3) ? 2'd0 : SP + 1'b1] <= dataIn;
                    count <= count + 1;
                    dataOut <= dataOut; // hold previous output
                end
                // else ignore push if full
            end else begin
                // Read operation (pop)
                if (count > 0) begin
                    dataOut <= stack_mem[SP];
                    // Clear popped location
                    stack_mem[SP] <= 4'd0;
                    // Decrement SP with wrap-around
                    SP <= (SP == 2'd0) ? 2'd3 : SP - 1'b1;
                    count <= count - 1;
                end else begin
                    // No data to pop; hold dataOut
                    dataOut <= dataOut;
                end
            end

            // Update EMPTY and FULL flags
            EMPTY <= (count == 3'd0);
            FULL  <= (count == 3'd4);
        end else begin
            // When EN is low, keep outputs and state unchanged
            dataOut <= dataOut;
            EMPTY <= EMPTY;
            FULL <= FULL;
            SP <= SP;
            count <= count;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= stack_mem[i];
        end
    end

endmodule