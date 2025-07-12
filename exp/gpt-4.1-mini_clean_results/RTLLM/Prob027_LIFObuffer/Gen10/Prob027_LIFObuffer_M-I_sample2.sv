module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,       // active high reset
    input  wire       EN,        // enable
    input  wire       RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack pointer: points to next free position, 0 (empty) .. 4 (full)
    reg [2:0] SP; // 3-bit unsigned to count 0..4

    // FSM state to handle pop pipelining
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        POP_WAIT = 2'b01
    } state_t;

    reg state_t state, next_state;

    // Buffer to hold popped data after SP decrement
    reg [3:0] pop_data;

    integer i;

    // State transition
    always @(posedge Clk) begin
        if (Rst) begin
            state <= IDLE;
        end else if (EN) begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Pop request and stack not empty triggers POP_WAIT
                if (EN && RW == 1'b1 && SP > 0)
                    next_state = POP_WAIT;
                else
                    next_state = IDLE;
            end
            POP_WAIT: begin
                // After one cycle, go back to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for SP, stack_mem, pop_data, and dataOut
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            pop_data <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            case (state)
                IDLE: begin
                    if (RW == 1'b0) begin
                        // Push operation (write)
                        if (SP < 4) begin
                            stack_mem[SP] <= dataIn;
                            SP <= SP + 1;
                        end
                        // else full, ignore push
                    end
                    // Pop operation handled in state machine
                end
                POP_WAIT: begin
                    // In POP_WAIT cycle, pop_data is read and output updated
                    pop_data <= stack_mem[SP - 1]; // Read popped data
                    SP <= SP - 1;                   // Decrement SP after capturing pop_data
                end
            endcase

            // Update dataOut only when pop_data is valid (in POP_WAIT)
            if (state == POP_WAIT) begin
                dataOut <= pop_data;
            end
            // Otherwise dataOut holds last value
        end
        // if EN=0, no operation, hold dataOut and state
    end

    // Flags combinational
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

endmodule