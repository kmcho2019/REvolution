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

    reg [3:0] stack_mem [0:3]; // 4 entries of 4 bits
    reg [2:0] SP;              // Stack pointer: number of valid entries (0-4)

    // Flags combinational from SP
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'b0;
            // Initialize stack memory to zeros
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
            end else begin
                // Read (pop)
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1]; // output top element after decrementing SP
                    // No need to clear stack_mem entry explicitly, SP manages valid depth
                end else begin
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule