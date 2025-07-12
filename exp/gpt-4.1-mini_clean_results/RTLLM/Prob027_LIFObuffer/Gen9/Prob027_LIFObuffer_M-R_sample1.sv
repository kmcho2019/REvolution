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

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;            // Number of elements in stack (0 to 4)
    reg [2:0] next_SP;

    // Combinational logic to calculate next_SP based on current SP and operation
    always @(*) begin
        next_SP = SP;
        if (EN && !Rst) begin
            if (RW == 1'b0) begin
                // Push operation if not full
                if (SP < 4)
                    next_SP = SP + 1;
            end else begin
                // Pop operation if not empty
                if (SP > 0)
                    next_SP = SP - 1;
            end
        end
    end

    // Sequential logic to update SP and dataOut
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
        end else if (EN) begin
            SP <= next_SP;
            if (RW == 1'b1 && SP > 0) begin
                // Pop operation: dataOut updated with top element before SP decremented
                dataOut <= stack_mem[SP - 1];
            end
        end
    end

    // Sequential block to write to stack_mem on push
    always @(posedge Clk) begin
        if (Rst) begin
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN && RW == 1'b0 && SP < 4) begin
            // Push operation: write dataIn to current SP position
            stack_mem[SP] <= dataIn;
        end
    end

    // Flags derived combinationally
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule