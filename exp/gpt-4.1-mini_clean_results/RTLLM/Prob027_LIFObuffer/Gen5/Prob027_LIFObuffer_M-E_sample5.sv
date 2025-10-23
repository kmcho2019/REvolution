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

    // Stack memory and pointer
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 0 to 4: number of valid entries

    integer i;

    // Flags derived from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (!FULL) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else: buffer full, no operation
            end else begin
                // Pop operation
                if (!EMPTY) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // No stack_mem clearing on pop to reduce toggling
                end
                // else: buffer empty, dataOut holds previous value
            end
        end
        // else EN=0: no operation, retain values
    end

endmodule