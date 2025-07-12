module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,        // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries, each 4 bits wide
    reg [3:0] stack_mem [3:0];

    // Stack pointer: number of elements currently in stack (0 to 4)
    reg [2:0] SP;

    // Temporary variable to hold popped data within the always block
    reg [3:0] pop_data;

    // Combinational empty/full flags based on SP count
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all stack memory elements explicitly for synthesis friendliness
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;

            SP <= 3'd0;
            dataOut <= 4'd0;
            pop_data <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation (write)
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn; // write input at current SP
                    SP <= SP + 1;
                    // dataOut remains unchanged on push
                end
                // else buffer full: no operation
            end else begin
                // Pop operation (read)
                if (SP > 3'd0) begin
                    SP <= SP - 1;            // decrement SP first
                    pop_data <= stack_mem[SP - 1]; // read popped data from previous top
                    dataOut <= stack_mem[SP - 1];  // update output with popped data
                    // stack_mem entry not cleared to minimize switching
                end
                // else buffer empty: no operation, dataOut holds last value
            end
        end
        // else EN low: no operation, maintain current state
    end

endmodule