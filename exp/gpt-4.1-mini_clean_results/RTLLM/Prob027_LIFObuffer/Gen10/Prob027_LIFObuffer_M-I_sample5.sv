module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;   // Stack Pointer: 0..4, where 4 = empty

    reg [2:0] next_SP;
    reg [3:0] next_dataOut;
    reg       operation_enable;

    // Combinational logic for next state and control
    always @(*) begin
        next_SP = SP;
        next_dataOut = dataOut;
        operation_enable = 1'b0;

        if (EN) begin
            if (RW == 1'b0) begin
                // Push operation if not full
                if (SP != 3'd0) begin
                    next_SP = SP - 1;
                    operation_enable = 1'b1;
                end
            end else begin
                // Pop operation if not empty
                if (SP != 3'd4) begin
                    next_dataOut = stack_mem[SP];
                    next_SP = SP + 1;
                    operation_enable = 1'b1;
                end
            end
        end
    end

    integer i;
    // Sequential logic for state update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty state
            dataOut <= 4'd0;
            // Avoid clearing stack_mem to reduce area and power
        end else begin
            if (operation_enable) begin
                SP <= next_SP;
                if (RW == 1'b0) begin
                    // Push operation: write data at new top (SP-1)
                    stack_mem[next_SP] <= dataIn;
                end else begin
                    // Pop operation: update dataOut
                    dataOut <= next_dataOut;
                end
            end
        end
    end

    // Flags derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule