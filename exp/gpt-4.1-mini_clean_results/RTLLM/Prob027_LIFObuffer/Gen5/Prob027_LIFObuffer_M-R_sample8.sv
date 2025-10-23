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
    reg [2:0] SP;   // Stack Pointer: 0..4, 4 means empty

    // Next state signals
    reg [2:0] next_SP;
    reg [3:0] next_dataOut;
    reg       pop_valid;
    reg       push_valid;

    integer i;

    // Combinational calculation of next state
    always @(*) begin
        next_SP = SP;
        next_dataOut = dataOut;
        pop_valid = 1'b0;
        push_valid = 1'b0;

        if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP != 3'd0) begin
                    next_SP = SP - 1;
                    push_valid = 1'b1;
                end
            end else begin
                // Read (pop)
                if (SP != 3'd4) begin
                    next_SP = SP + 1;
                    pop_valid = 1'b1;
                    next_dataOut = stack_mem[SP];
                end
            end
        end
    end

    // Synchronous update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty pointer
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            SP <= next_SP;
            dataOut <= next_dataOut;

            if (push_valid) begin
                stack_mem[SP - 1] <= dataIn; // Push at SP - 1
            end
            // No need to clear on pop to save toggling
        end
    end

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule