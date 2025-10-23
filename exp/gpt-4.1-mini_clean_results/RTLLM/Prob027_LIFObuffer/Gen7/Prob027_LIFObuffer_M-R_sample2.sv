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
    reg [2:0] SP; // Number of elements in stack (0 to 4)
    reg [3:0] next_dataOut;

    // Combinational logic to determine next_dataOut on pop
    always @(*) begin
        if (RW && (SP > 0)) begin
            // On pop, dataOut should be top of stack (SP-1)
            next_dataOut = stack_mem[SP - 1];
        end else begin
            // Otherwise hold current value
            next_dataOut = dataOut;
        end
    end

    // Sequential logic for stack pointer and memory updates
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
            dataOut <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation if not full
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // dataOut remains unchanged here; will update in next always block
            end else begin
                // Pop operation if not empty
                if (SP > 0) begin
                    SP <= SP - 1;
                    // Clear popped location to reduce toggling (optional)
                    stack_mem[SP - 1] <= 4'd0;
                end
                // dataOut update deferred to next block
            end
        end
    end

    // Sequential logic to update dataOut register
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'd0;
        end else if (EN) begin
            dataOut <= next_dataOut;
        end
        // Else dataOut holds value
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule