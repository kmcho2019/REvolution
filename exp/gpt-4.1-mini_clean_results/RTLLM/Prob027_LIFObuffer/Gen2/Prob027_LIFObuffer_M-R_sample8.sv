module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: values 0..4, 4 means empty (points beyond top)

    // Synchronous stack pointer update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty
        end else if (EN) begin
            if (RW == 1'b0) begin // Write (push)
                if (SP != 0) begin
                    SP <= SP - 1;
                end
            end else begin // Read (pop)
                if (SP != 4) begin
                    SP <= SP + 1;
                end
            end
        end
    end

    // Stack memory write on push
    always @(posedge Clk) begin
        if (Rst) begin
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut     <= 4'b0;
        end else if (EN) begin
            if (RW == 1'b0) begin // push
                if (SP != 0) begin
                    stack_mem[SP - 1] <= dataIn;
                end
            end else begin // pop
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    // Do not clear stack_mem at pop for power efficiency
                end
            end
        end
    end

    // Flags derived combinationally to reduce toggling logic
    assign EMPTY = (SP == 4);
    assign FULL  = (SP == 0);

endmodule