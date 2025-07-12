module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: 3 bits; 4 means empty, 0 means full
    reg [2:0] SP;
    reg [2:0] next_SP;

    // Internal write enable for stack memory
    reg mem_wr_en;
    reg [2:0] mem_wr_addr;
    reg [3:0] mem_wr_data;

    integer i;

    // Flags (combinational)
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    // Next state logic for SP and stack memory
    always @(*) begin
        // Default assignments (hold)
        next_SP = SP;
        mem_wr_en = 1'b0;
        mem_wr_addr = 3'd0;
        mem_wr_data = 4'd0;

        if (Rst) begin
            next_SP = 3'd4;  // Empty
        end else if (EN) begin
            if (RW == 1'b0 && SP != 3'd0) begin
                // Write operation (push)
                next_SP = SP - 1;
                mem_wr_en = 1'b1;
                mem_wr_addr = SP - 1;
                mem_wr_data = dataIn;
            end else if (RW == 1'b1 && SP != 3'd4) begin
                // Read operation (pop)
                next_SP = SP + 1;
                // dataOut updated in sequential always block
                // no memory clearing to reduce switching
            end
        end
    end

    // Sequential logic block
    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            // Optional: skip clearing stack_mem for synthesis efficiency
            // If necessary, uncomment the below loop:
            // for (i = 0; i < 4; i = i + 1)
            //     stack_mem[i] <= 4'd0;
        end else begin
            SP <= next_SP;

            if (mem_wr_en)
                stack_mem[mem_wr_addr] <= mem_wr_data;

            if (EN && RW == 1'b1 && SP != 3'd4)
                dataOut <= stack_mem[SP];
        end
    end

endmodule