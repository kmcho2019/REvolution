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

    // Intermediate variable for pop data read index
    reg [3:0] pop_data;

    // Empty when SP==0, Full when SP==4
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Clear stack memory for reset (optional but good practice)
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn; // Write data at SP index
                    SP <= SP + 1;
                    // dataOut unchanged on push
                end
                // else full - no operation
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    pop_data <= stack_mem[SP - 1]; // Read element to pop_data
                    dataOut <= stack_mem[SP - 1];  // Update dataOut with popped data
                    // Do not clear stack_mem location to reduce switching
                end
                // else empty - no operation, dataOut holds previous value
            end
        end
        // else EN low: no operation, maintain state
    end

endmodule