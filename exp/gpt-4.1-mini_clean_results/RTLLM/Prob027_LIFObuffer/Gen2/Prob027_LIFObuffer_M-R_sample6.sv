module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output wire [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries of 4-bit stack
    reg [2:0] SP;              // stack pointer, 0..4; 4 = empty

    // Write enable signals for stack entries
    reg [3:0] we_stack;        // one-hot write enable signals for stack_mem entries
    reg [3:0] data_to_write;   // data to write for each entry

    integer i;

    // Sequential logic: stack pointer update and control signals
    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            SP <= 3'd4; // empty stack
            we_stack <= 4'b0000;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            we_stack <= 4'b0000; // default no write
            if (RW == 1'b0) begin
                // Write operation (push)
                if (SP != 0) begin
                    SP <= SP - 1;
                    we_stack[SP - 1] <= 1'b1;
                    data_to_write <= dataIn;
                end
                // else full, no change
            end else begin
                // Read operation (pop)
                if (SP != 4) begin
                    // Pop: increment SP (discarding data)
                    SP <= SP + 1;
                    // No explicit clearing to reduce toggling
                end
                // else empty, no change
            end
        end else begin
            we_stack <= 4'b0000; // no operation
        end
    end

    // Sequential logic: stack memory write
    always @(posedge Clk) begin
        for (i = 0; i < 4; i = i + 1) begin
            if (we_stack[i])
                stack_mem[i] <= data_to_write;
        end
    end

    // Combinational outputs and flags
    assign EMPTY = (SP == 4);
    assign FULL  = (SP == 0);

    // dataOut: if not empty, output top of stack, else zero
    assign dataOut = (SP != 4) ? stack_mem[SP] : 4'd0;

endmodule