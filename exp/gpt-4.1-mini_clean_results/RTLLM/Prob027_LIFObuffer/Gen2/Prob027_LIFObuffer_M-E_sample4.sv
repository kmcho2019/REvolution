module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output reg         EMPTY,
    output reg         FULL
);
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: 0..4 (0 = empty, 4 = full)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Initialize stack memory to zero on reset
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'b0000;
            end
            SP <= 3'd0;       // Empty stack
            dataOut <= 4'b0000;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
        end else if (EN) begin
            // Default next values
            reg [2:0] next_SP;
            reg [3:0] next_dataOut;

            next_SP = SP;
            next_dataOut = dataOut;

            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;  // Write at current SP
                    next_SP = SP + 1;         // Increment SP
                end
                // dataOut retains previous value on push
            end else begin
                // Read operation (pop)
                if (SP > 0) begin
                    next_SP = SP - 1;             // Decrement SP first
                    next_dataOut = stack_mem[next_SP];  // Read from new SP location
                    // Do NOT clear memory to save power
                end
                // If empty, hold dataOut
            end

            // Update registers synchronously
            SP <= next_SP;
            dataOut <= next_dataOut;

            // Update flags based on next_SP
            EMPTY <= (next_SP == 0);
            FULL  <= (next_SP == 4);
        end
    end
endmodule