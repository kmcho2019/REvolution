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
    reg [2:0] SP;              // stack pointer, range 0-4

    integer i;
    reg [2:0] next_SP;
    reg [3:0] pop_data;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;           // empty stack
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            next_SP = SP;        // default next_SP is current SP
            pop_data = 4'd0;     // default pop_data

            if (RW == 1'b0) begin
                // Push operation if not full
                if (SP != 0) begin
                    next_SP = SP - 1;
                    stack_mem[next_SP] <= dataIn; // write at new SP location
                end
            end else begin
                // Pop operation if not empty
                if (SP != 4) begin
                    pop_data = stack_mem[SP];
                    next_SP = SP + 1;
                    // Clearing popped location is optional; omit for power efficiency
                    // stack_mem[SP] <= 4'd0;
                end else begin
                    pop_data = dataOut; // retain previous dataOut if empty
                end
            end

            // Update SP and dataOut with new values
            SP <= next_SP;
            if (RW == 1'b1 && SP != 4) begin
                dataOut <= pop_data;
            end

            // Update flags based on next_SP (updated SP)
            EMPTY <= (next_SP == 4);
            FULL  <= (next_SP == 0);
        end
    end

endmodule