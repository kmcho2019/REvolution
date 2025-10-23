module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // Counts from 4 (empty) down to 0 (full)
    reg [2:0] SP;

    // Next state signals
    reg [2:0] next_SP;
    reg [3:0] next_dataOut;
    reg       write_enable [3:0];
    reg [3:0] write_data [3:0];

    integer i;

    // Combinational logic to determine next_SP, write enables and dataOut
    always @* begin
        // Default assignments: hold current state
        next_SP = SP;
        next_dataOut = dataOut;
        // By default, no writes to stack memory
        for (i = 0; i < 4; i = i + 1) begin
            write_enable[i] = 1'b0;
            write_data[i] = 4'd0;
        end

        // Conditions for push and pop
        // push: EN=1, RW=0, and not full (SP != 0)
        // pop:  EN=1, RW=1, and not empty (SP != 4)
        if (EN) begin
            if (Rst) begin
                // Handled in sequential block
            end else begin
                if ((RW == 1'b0) && (SP != 3'd0)) begin
                    // Push operation
                    next_SP = SP - 3'd1;
                    // Write dataIn into stack_mem[SP-1]
                    write_enable[SP - 3'd1] = 1'b1;
                    write_data[SP - 3'd1] = dataIn;
                end else if ((RW == 1'b1) && (SP != 3'd4)) begin
                    // Pop operation
                    next_dataOut = stack_mem[SP];
                    next_SP = SP + 3'd1;
                    // No stack_mem clearing to save toggling
                end
                // else no operation, hold state
            end
        end
    end

    // Sequential logic: registers update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            SP <= next_SP;
            dataOut <= next_dataOut;
            for (i = 0; i < 4; i = i + 1) begin
                if (write_enable[i]) begin
                    stack_mem[i] <= write_data[i];
                end
            end
        end
    end

    // EMPTY and FULL flags derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule