module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory
reg [BUFFER_SIZE-1:0] SP; // Stack pointer

// Initialize stack pointer and flags
initial begin
    SP = BUFFER_SIZE;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// State machine for buffer operations
reg [1:0] state, next_state;
parameter IDLE = 2'b00, WRITE = 2'b01, READ = 2'b10;

always @(*) begin
    case (state)
        IDLE: begin
            if (EN && !RW && SP > 0) next_state = WRITE;
            else if (EN && RW && SP < BUFFER_SIZE) next_state = READ;
            else next_state = IDLE;
        end
        WRITE: next_state = IDLE;
        READ: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state transition and stack operations
always @(posedge Clk) begin
    if (Rst) begin
        state <= IDLE;
        SP <= BUFFER_SIZE;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}};
        end
        dataOut <= {DATA_WIDTH{1'b0}};
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            WRITE: begin
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
                if (SP == 0) FULL <= 1'b1;
                EMPTY <= 1'b0;
            end
            READ: begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= {DATA_WIDTH{1'b0}};
                SP <= SP + 1;
                if (SP == BUFFER_SIZE) EMPTY <= 1'b1;
                FULL <= 1'b0;
            end
            default: ;
        endcase
    end
end

// Combinational logic for flags
assign EMPTY = (SP == BUFFER_SIZE);
assign FULL = (SP == 0);

endmodule