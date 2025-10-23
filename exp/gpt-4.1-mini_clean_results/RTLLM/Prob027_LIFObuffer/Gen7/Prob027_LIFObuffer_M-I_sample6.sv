module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [0:3]; // 4 entries x 4 bits
    reg [2:0] SP;              // Stack pointer: points to next pop position (0 to 4)

    // FULL when SP==0 (no room to push), EMPTY when SP==4 (no data to pop)
    assign FULL  = (SP == 3'd0);
    assign EMPTY = (SP == 3'd4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // Empty buffer indicated by SP=4
            dataOut <= 4'b0;
            // Clear stack memory
            for (i=0; i<4; i=i+1)
                stack_mem[i] <= 4'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) if not full
                if (!FULL) begin
                    SP <= SP - 3'd1;           // Decrement SP to point to new top
                    stack_mem[SP - 3'd1] <= dataIn; // Write dataIn at new top
                    // dataOut unchanged on push
                end
            end else begin
                // Read (pop) if not empty
                if (!EMPTY) begin
                    dataOut <= stack_mem[SP];   // Output current top data
                    stack_mem[SP] <= 4'b0;      // Clear popped location
                    SP <= SP + 3'd1;            // Increment SP to point next top
                end else begin
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule