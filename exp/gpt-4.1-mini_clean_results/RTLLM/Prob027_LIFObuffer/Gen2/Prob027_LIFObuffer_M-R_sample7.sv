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
    reg [2:0] SP; // Stack pointer: 0..4, where 4 = empty

    // Next state signals
    reg [2:0] next_SP;
    reg [3:0] next_dataOut;
    reg next_EMPTY, next_FULL;

    integer i;

    // Combinational logic to determine next state and outputs
    always @(*) begin
        // Defaults: hold current state
        next_SP = SP;
        next_dataOut = dataOut;
        next_EMPTY = (SP == 4);
        next_FULL  = (SP == 0);

        if (Rst) begin
            next_SP = 3'd4;      // Empty stack
            next_dataOut = 4'b0;
            next_EMPTY = 1'b1;
            next_FULL  = 1'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (SP != 0) begin
                    next_SP = SP - 1;
                    // On push, dataOut holds previous value
                end
                // else full, no change
            end else begin
                // Read (pop) operation
                if (SP != 4) begin
                    next_dataOut = stack_mem[SP];
                    next_SP = SP + 1;
                    // Do NOT clear stack_mem to reduce switching
                end
                // else empty, no change
            end
            next_EMPTY = (next_SP == 4);
            next_FULL  = (next_SP == 0);
        end
    end

    // Sequential logic: update state and memory on clock edge
    always @(posedge Clk) begin
        if (Rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0000;
            end
            SP <= 3'd4;
            dataOut <= 4'b0000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (EN) begin
            if (RW == 1'b0 && SP != 0) begin
                // Write: push dataIn to stack_mem[next_SP]
                stack_mem[next_SP] <= dataIn;
            end
            // On pop, do not clear stack_mem to reduce toggling

            SP <= next_SP;
            dataOut <= next_dataOut;
            EMPTY <= next_EMPTY;
            FULL <= next_FULL;
        end
    end
endmodule