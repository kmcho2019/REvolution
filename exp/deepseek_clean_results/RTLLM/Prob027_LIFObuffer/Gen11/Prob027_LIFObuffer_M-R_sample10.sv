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

    // State encoding
    localparam EMPTY_ST = 2'b00;
    localparam LOADED_ST = 2'b01;
    localparam FULL_ST = 2'b10;
    
    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    reg [1:0] state;
    reg [1:0] SP;  // Stack pointer
    
    // Combinational outputs
    assign EMPTY = (state == EMPTY_ST);
    assign FULL = (state == FULL_ST);
    assign dataOut = stack_mem[SP];
    
    always @(posedge Clk) begin
        if (Rst) begin
            state <= EMPTY_ST;
            SP <= 2'b00;
        end
        else if (EN) begin
            case (state)
                EMPTY_ST: begin
                    if (!RW) begin  // Write
                        stack_mem[0] <= dataIn;
                        state <= LOADED_ST;
                        SP <= 2'b00;
                    end
                end
                
                LOADED_ST: begin
                    if (!RW && !FULL) begin  // Write
                        if (SP == 2'b10) begin
                            state <= FULL_ST;
                        end
                        SP <= SP + 1;
                        stack_mem[SP + 1] <= dataIn;
                    end
                    else if (RW) begin  // Read
                        if (SP == 2'b00) begin
                            state <= EMPTY_ST;
                        end
                        else begin
                            SP <= SP - 1;
                        end
                    end
                end
                
                FULL_ST: begin
                    if (RW) begin  // Read
                        state <= LOADED_ST;
                        SP <= SP - 1;
                    end
                end
            endcase
        end
    end

endmodule