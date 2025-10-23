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

    // State definitions
    parameter EMPTY_STATE = 2'b00;
    parameter ONE_ENTRY   = 2'b01;
    parameter TWO_ENTRIES = 2'b10;
    parameter FULL_STATE  = 2'b11;
    
    reg [1:0] current_state, next_state;
    reg [3:0] stack_mem [0:3];
    
    // State register
    always @(posedge Clk) begin
        if (Rst) begin
            current_state <= EMPTY_STATE;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = current_state;
        if (EN) begin
            case (current_state)
                EMPTY_STATE: if (!RW) next_state = ONE_ENTRY;
                ONE_ENTRY:   next_state = RW ? EMPTY_STATE : TWO_ENTRIES;
                TWO_ENTRIES: next_state = RW ? ONE_ENTRY : FULL_STATE;
                FULL_STATE:  if (RW) next_state = TWO_ENTRIES;
            endcase
        end
    end
    
    // Memory operations
    always @(posedge Clk) begin
        if (Rst) begin
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end else if (EN) begin
            if (!RW && (current_state != FULL_STATE)) begin
                // Push operation
                case (current_state)
                    EMPTY_STATE: stack_mem[0] <= dataIn;
                    ONE_ENTRY:   stack_mem[1] <= dataIn;
                    TWO_ENTRIES: stack_mem[2] <= dataIn;
                endcase
            end else if (RW && (current_state != EMPTY_STATE)) begin
                // Pop operation
                case (current_state)
                    ONE_ENTRY:   dataOut <= stack_mem[0];
                    TWO_ENTRIES: dataOut <= stack_mem[1];
                    FULL_STATE:  dataOut <= stack_mem[2];
                endcase
            end
        end
    end
    
    // Output assignments
    assign EMPTY = (current_state == EMPTY_STATE);
    assign FULL  = (current_state == FULL_STATE);

endmodule