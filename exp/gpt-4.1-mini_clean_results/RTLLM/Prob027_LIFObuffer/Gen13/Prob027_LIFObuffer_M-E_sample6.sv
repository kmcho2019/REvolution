module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,         // 0: push, 1: pop
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack pointer: points to next free slot (0..4)
    reg [2:0] SP;

    // Next value for SP (used internally for clarity)
    reg [2:0] next_SP;

    // EMPTY and FULL flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Sequential logic: Update SP and stack_mem on clock edge
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Reset stack memory to zero
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation (write)
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 3'd1;
                    // dataOut not changed on push
                end
            end else begin
                // Pop operation (read)
                if (SP > 3'd0) begin
                    SP <= SP - 3'd1;
                    // dataOut updated combinationally below
                end
                // else no pop if empty
            end
        end
        // else EN low: hold state
    end

    // Combinational logic: update dataOut to current top of stack
    always @(*) begin
        if (Rst) begin
            dataOut = 4'd0;
        end else if (EN && RW && (SP != 3'd0)) begin
            // During a pop operation, output the element at SP-1 (top of stack)
            dataOut = stack_mem[SP - 3'd1];
        end else if (EN && RW && (SP == 3'd0)) begin
            // Buffer empty on pop: dataOut unchanged (keep previous)
            dataOut = dataOut;
        end else begin
            // Hold last value (or during push, hold dataOut)
            dataOut = dataOut;
        end
    end

endmodule