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

    // Stack memory implemented as shift register
    reg [3:0] stack_mem [0:3];
    
    // Status register (gray coded)
    reg [1:0] state;
    localparam EMPTY_STATE = 2'b00;
    localparam ONE_ITEM    = 2'b01;
    localparam TWO_ITEMS   = 2'b11;
    localparam FULL_STATE  = 2'b10;
    
    // Combinational outputs
    assign EMPTY = (state == EMPTY_STATE);
    assign FULL = (state == FULL_STATE);
    assign dataOut = stack_mem[0];  // Always output top of stack

    always @(posedge Clk) begin
        if (Rst) begin
            state <= EMPTY_STATE;
            // Only reset the first location (others will be overwritten)
            stack_mem[0] <= 4'b0;
        end
        else if (EN) begin
            case (state)
                EMPTY_STATE: 
                    if (!RW) begin  // Write operation
                        stack_mem[0] <= dataIn;
                        state <= ONE_ITEM;
                    end
                
                ONE_ITEM:
                    if (!RW) begin  // Write
                        // Shift and insert
                        stack_mem[1] <= stack_mem[0];
                        stack_mem[0] <= dataIn;
                        state <= TWO_ITEMS;
                    end
                    else begin      // Read
                        state <= EMPTY_STATE;
                    end
                
                TWO_ITEMS:
                    if (!RW) begin  // Write
                        // Shift and insert
                        stack_mem[2] <= stack_mem[1];
                        stack_mem[1] <= stack_mem[0];
                        stack_mem[0] <= dataIn;
                        state <= FULL_STATE;
                    end
                    else begin      // Read
                        // Unshift
                        stack_mem[0] <= stack_mem[1];
                        state <= ONE_ITEM;
                    end
                
                FULL_STATE:
                    if (RW) begin  // Read
                        // Unshift
                        stack_mem[0] <= stack_mem[1];
                        stack_mem[1] <= stack_mem[2];
                        stack_mem[2] <= stack_mem[3];
                        state <= TWO_ITEMS;
                    end
                    // On write when full: no operation (data ignored)
            endcase
        end
    end

    // Initialize remaining memory locations (optimized for synthesis)
    initial begin
        stack_mem[1] = 4'b0;
        stack_mem[2] = 4'b0;
        stack_mem[3] = 4'b0;
    end

endmodule