module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // One-hot encoded stack pointer (4 bits)
    reg [3:0] SP;
    
    // Operation validation signal
    wire op_valid = EN && ((!RW && !FULL) || (RW && !EMPTY));
    
    // Next stack pointer calculation
    wire [3:0] next_SP = (!RW) ? {SP[2:0], 1'b0} : {1'b0, SP[3:1]};
    
    // Combinational flag assignments
    assign EMPTY = (SP == 4'b0001);
    assign FULL = (SP[3] == 1'b1);
    
    // Clock gating for memory writes
    wire mem_write_clk = Clk & op_valid & !RW;
    wire [3:0] mem_write_en = SP & {4{mem_write_clk}};

    // Control logic: Stack pointer
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 4'b0001;  // Initialize to empty (one-hot)
        end
        else if (op_valid) begin
            SP <= next_SP;
        end
    end

    // Data path: Memory writes (clock gated)
    always @(posedge mem_write_clk) begin
        case (1'b1)
            mem_write_en[0]: stack_mem[0] <= dataIn;
            mem_write_en[1]: stack_mem[1] <= dataIn;
            mem_write_en[2]: stack_mem[2] <= dataIn;
            mem_write_en[3]: stack_mem[3] <= dataIn;
        endcase
    end

    // Data path: Output reads
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'b0;
        end
        else if (op_valid && RW) begin
            case (1'b1)
                SP[0]: dataOut <= stack_mem[0];
                SP[1]: dataOut <= stack_mem[1];
                SP[2]: dataOut <= stack_mem[2];
                SP[3]: dataOut <= stack_mem[3];
            endcase
        end
    end

endmodule