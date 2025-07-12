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

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;             // Number of elements in stack (0..4)
    reg [2:0] next_SP;
    reg [3:0] next_dataOut;
    reg       do_push;
    reg       do_pop;

    integer i;

    // Combinational logic for next state and control signals
    always @(*) begin
        next_SP = SP;
        next_dataOut = dataOut;
        do_push = 1'b0;
        do_pop = 1'b0;

        if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 3'd4) begin
                    next_SP = SP + 1;
                    do_push = 1'b1;
                    // dataOut unchanged on push
                end
            end else begin
                // Read (pop)
                if (SP > 3'd0) begin
                    next_SP = SP - 1;
                    do_pop = 1'b1;
                    next_dataOut = stack_mem[SP - 1];
                end
                // else dataOut retains previous value
            end
        end
    end

    // Synchronous update of SP, dataOut, and stack memory
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            SP <= next_SP;
            dataOut <= next_dataOut;

            if (do_push) begin
                stack_mem[SP] <= dataIn; // Push at current SP
            end
            // Do not clear stack_mem on pop to reduce toggling
        end
    end

    // Flags combinationally derived
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule