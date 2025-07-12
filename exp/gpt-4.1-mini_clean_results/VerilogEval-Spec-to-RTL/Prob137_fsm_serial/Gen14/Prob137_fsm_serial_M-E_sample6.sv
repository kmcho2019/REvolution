module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded states
    localparam IDLE       = 9'b000000001;
    localparam START      = 9'b000000010;
    localparam DATA0      = 9'b000000100;
    localparam DATA1      = 9'b000001000;
    localparam DATA2      = 9'b000010000;
    localparam DATA3      = 9'b000100000;
    localparam DATA4      = 9'b001000000;
    localparam DATA5      = 9'b010000000;
    localparam DATA6      = 9'b100000000;
    // Note: We will define DATA7 as a separate state to receive last data bit
    // and then check stop bit in STOP state
    localparam DATA7      = 9'b000000000; // We'll assign DATA7 to a separate bit later
    // Actually, 9 bits only so let's add STOP and ERROR_WAIT states as well:
    // We'll need more bits than 9 for all these states: 11 states needed
    // So extend to 11 bits:
    // Redefine with 11 bits for clarity:
    
    // Re-define all with 11 bits
    localparam IDLE       = 11'b00000000001;
    localparam START      = 11'b00000000010;
    localparam DATA0      = 11'b00000000100;
    localparam DATA1      = 11'b00000001000;
    localparam DATA2      = 11'b00000010000;
    localparam DATA3      = 11'b00000100000;
    localparam DATA4      = 11'b00001000000;
    localparam DATA5      = 11'b00010000000;
    localparam DATA6      = 11'b00100000000;
    localparam DATA7      = 11'b01000000000;
    localparam STOP       = 11'b10000000000;
    localparam ERROR_WAIT = 11'b000000000000; // Need 12 bits total to fit this too

    // So increase to 12 bits for ERROR_WAIT as well
    localparam IDLE_E       = 12'b000000000001;
    localparam START_E      = 12'b000000000010;
    localparam DATA0_E      = 12'b000000000100;
    localparam DATA1_E      = 12'b000000001000;
    localparam DATA2_E      = 12'b000000010000;
    localparam DATA3_E      = 12'b000000100000;
    localparam DATA4_E      = 12'b000001000000;
    localparam DATA5_E      = 12'b000010000000;
    localparam DATA6_E      = 12'b000100000000;
    localparam DATA7_E      = 12'b001000000000;
    localparam STOP_E       = 12'b010000000000;
    localparam ERROR_WAIT_E = 12'b100000000000;

    // Use these 12-bit one-hot states for the FSM
    reg [11:0] state, next_state;

    reg [7:0] shift_reg;

    // Next state logic combinational
    always @(*) begin
        next_state = 12'b0;
        case(1'b1)
            state[0]: // IDLE
                if (in == 1'b0)
                    next_state = START_E;
                else
                    next_state = IDLE_E;

            state[1]: // START
                next_state = DATA0_E;

            state[2]: // DATA0
                next_state = DATA1_E;

            state[3]: // DATA1
                next_state = DATA2_E;

            state[4]: // DATA2
                next_state = DATA3_E;

            state[5]: // DATA3
                next_state = DATA4_E;

            state[6]: // DATA4
                next_state = DATA5_E;

            state[7]: // DATA5
                next_state = DATA6_E;

            state[8]: // DATA6
                next_state = DATA7_E;

            state[9]: // DATA7
                next_state = STOP_E;

            state[10]: // STOP
                if (in == 1'b1)
                    next_state = IDLE_E;
                else
                    next_state = ERROR_WAIT_E;

            state[11]: // ERROR_WAIT
                if (in == 1'b1)
                    next_state = IDLE_E;
                else
                    next_state = ERROR_WAIT_E;

            default:
                next_state = IDLE_E;
        endcase
    end

    // Sequential state and shift register update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE_E;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0
            done <= 1'b0;

            // Shift register updated only in DATA states
            case(1'b1)
                state[1]: /* START */ ;
                state[2]: shift_reg <= {in, shift_reg[7:1]}; // DATA0
                state[3]: shift_reg <= {in, shift_reg[7:1]}; // DATA1
                state[4]: shift_reg <= {in, shift_reg[7:1]}; // DATA2
                state[5]: shift_reg <= {in, shift_reg[7:1]}; // DATA3
                state[6]: shift_reg <= {in, shift_reg[7:1]}; // DATA4
                state[7]: shift_reg <= {in, shift_reg[7:1]}; // DATA5
                state[8]: shift_reg <= {in, shift_reg[7:1]}; // DATA6
                state[9]: shift_reg <= {in, shift_reg[7:1]}; // DATA7
                default: shift_reg <= shift_reg; // hold
            endcase

            // Generate done pulse on valid stop bit reception
            if (state[10] && in == 1'b1) begin
                done <= 1'b1;
            end
        end
    end

endmodule