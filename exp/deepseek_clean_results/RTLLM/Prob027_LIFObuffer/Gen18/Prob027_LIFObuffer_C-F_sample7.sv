module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output wire [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer and empty state
    reg [1:0] SP;
    reg empty_state;

    // Combinational outputs
    assign EMPTY = empty_state;
    assign FULL = (!empty_state && (SP == 2'b11));
    assign dataOut = empty_state ? 4'b0 : stack_mem[SP];

    // Stack control logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'b00;
            empty_state <= 1'b1;
            // Initialize only first location (others will be overwritten)
            stack_mem[0] <= 4'b0;
        end
        else if (EN) begin
            case ({RW, empty_state})
                2'b00: begin  // Write when not empty
                    stack_mem[SP + 1] <= dataIn;
                    SP <= SP + 1;
                end
                2'b01: begin  // First write when empty
                    stack_mem[0] <= dataIn;
                    empty_state <= 1'b0;
                end
                2'b10: begin  // Read when not empty
                    if (SP == 2'b00) begin
                        empty_state <= 1'b1;
                    end
                    else begin
                        SP <= SP - 1;
                    end
                end
                // 2'b11: Read when empty - no operation
            endcase
        end
    end

endmodule