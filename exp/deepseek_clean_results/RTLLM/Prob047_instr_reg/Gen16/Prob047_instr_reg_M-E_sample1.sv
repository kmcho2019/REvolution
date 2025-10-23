module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        LOAD_P1,
        LOAD_P2,
        SHIFT
    } state_t;

    reg [15:0] shift_reg;  // Combined storage for both instruction parts
    state_t current_state, next_state;

    // State machine transition logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
            shift_reg <= 16'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                LOAD_P1: shift_reg[15:8] <= data;
                LOAD_P2: shift_reg[7:0] <= data;
                SHIFT: shift_reg <= {shift_reg[7:0], 8'b0};
                default: shift_reg <= shift_reg;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (fetch == 2'b01) next_state = LOAD_P1;
                else if (fetch == 2'b10) next_state = LOAD_P2;
            end
            LOAD_P1: next_state = (fetch == 2'b10) ? SHIFT : IDLE;
            LOAD_P2: next_state = IDLE;
            SHIFT: next_state = LOAD_P2;
        endcase
    end

    // Output generation
    always @(*) begin
        ins = shift_reg[15:13];
        ad1 = shift_reg[12:8];
        ad2 = shift_reg[7:0];
    end

endmodule