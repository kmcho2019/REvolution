module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries x 4 bits
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: number of valid entries (0-4)

    integer i;

    // Flags combinationally from SP
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'b0;
            // Initialize stack memory to zero
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                    // dataOut unchanged on push
                end
                // else full: no operation
            end else begin
                // Read (pop)
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Optional: clear popped location (not strictly necessary)
                    stack_mem[SP - 1] <= 4'b0;
                end else begin
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule