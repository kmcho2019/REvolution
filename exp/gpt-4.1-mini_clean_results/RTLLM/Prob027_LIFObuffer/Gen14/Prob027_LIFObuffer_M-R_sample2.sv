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

    // FSM states
    typedef enum reg [1:0] {IDLE=2'd0, PUSH=2'd1, POP=2'd2} state_t;
    reg [1:0] state, next_state;

    integer i;

    // Combinational next state logic
    always @(*) begin
        if (Rst) begin
            next_state = IDLE;
        end else if (~EN) begin
            next_state = IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (RW == 1'b0 && SP != 3'd0)
                        next_state = PUSH;
                    else if (RW == 1'b1 && SP != 3'd4)
                        next_state = POP;
                    else
                        next_state = IDLE;
                end
                PUSH: next_state = IDLE;
                POP: next_state = IDLE;
                default: next_state = IDLE;
            endcase
        end
    end

    // Sequential FSM state update
    always @(posedge Clk) begin
        if (Rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Sequential SP, stack_mem, dataOut update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;  // empty stack
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            case (state)
                PUSH: begin
                    // Push data at SP-1 position, then decrement SP
                    stack_mem[SP - 3'd1] <= dataIn;
                    SP <= SP - 3'd1;
                end
                POP: begin
                    // Pop data from SP position, then increment SP
                    dataOut <= stack_mem[SP];
                    // Optional: stack_mem[SP] <= 4'd0; // not cleared to save power
                    SP <= SP + 3'd1;
                end
                default: begin
                    dataOut <= dataOut;
                    SP <= SP;
                end
            endcase
        end
    end

    // Flags for empty and full
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule