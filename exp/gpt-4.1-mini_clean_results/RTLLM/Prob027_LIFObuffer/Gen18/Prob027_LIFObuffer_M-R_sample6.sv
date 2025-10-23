module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [0:3];
    reg [2:0] SP;  // Stack pointer: 4 means empty, 0 means full

    // State machine states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        PUSH = 2'b01,
        POP  = 2'b10
    } state_t;

    state_t curr_state, next_state;

    // Combinational logic to determine next state
    always @(*) begin
        if (Rst) begin
            next_state = IDLE;
        end else if (EN) begin
            if ((RW == 1'b0) && (SP != 3'd0)) // write and not full
                next_state = PUSH;
            else if ((RW == 1'b1) && (SP != 3'd4)) // read and not empty
                next_state = POP;
            else
                next_state = IDLE;
        end else begin
            next_state = IDLE;
        end
    end

    integer i;

    // Sequential logic: state update and stack pointer, stack memory, dataOut updates
    always @(posedge Clk) begin
        if (Rst) begin
            curr_state <= IDLE;
            SP <= 3'd4;  // Empty stack
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            curr_state <= next_state;

            case (next_state)
                PUSH: begin
                    // Push dataIn onto stack at SP-1, then decrement SP
                    stack_mem[SP - 3'd1] <= dataIn;
                    SP <= SP - 3'd1;
                end
                POP: begin
                    // Pop data from stack_mem at SP into dataOut, then increment SP
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 3'd1;
                end
                default: begin
                    // No operation, maintain SP and dataOut
                    SP <= SP;
                    dataOut <= dataOut;
                end
            endcase
        end
    end

    // Flags for empty and full are combinational
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule