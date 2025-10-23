module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Parameters
    localparam DEPTH = 4;
    localparam PTR_WIDTH = 3; // Enough to count to DEPTH

    // Stack memory and pointer
    reg [3:0] stack_mem [0:DEPTH-1];
    reg [PTR_WIDTH-1:0] SP; // Points to next free location (0 when empty)

    integer i;

    // Assign flags based on SP
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == DEPTH);

    // Initialize stack memory at reset using generate block for synthesis friendliness
    genvar idx;
    generate
        for (idx = 0; idx < DEPTH; idx = idx + 1) begin : INIT_MEM
            always @(posedge Clk) begin
                if (Rst) begin
                    stack_mem[idx] <= 4'd0;
                end
            end
        end
    endgenerate

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < DEPTH) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else full, do nothing
            end else begin
                // Pop operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
                // else empty, dataOut holds previous value
            end
        end
        // else EN=0, no operation
    end

endmodule