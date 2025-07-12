module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM States
    typedef enum logic [0:0] {
        IDLE  = 1'b0,  // waiting for first byte
        WAIT2 = 1'b1   // waiting for second byte
    } state_t;

    state_t state, state_next;
    reg [7:0] first_byte;

    // Signal indicates that second byte has arrived and output should be registered next cycle
    reg second_byte_arrived;

    // FSM state transition and first_byte latch
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            first_byte  <= 8'd0;
            second_byte_arrived <= 1'b0;
        end else begin
            state <= state_next;
            if (state == IDLE && valid_in) begin
                first_byte <= data_in;
            end
            // second_byte_arrived pulse generated when second byte is received in WAIT2 state
            second_byte_arrived <= (state == WAIT2 && valid_in);
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: 
                if (valid_in)
                    state_next = WAIT2;
                else
                    state_next = IDLE;
            WAIT2:
                if (valid_in)
                    state_next = IDLE;
                else
                    state_next = WAIT2;
            default:
                state_next = IDLE;
        endcase
    end

    // Output registers update, valid_out asserted one cycle after second byte arrival
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 16'd0;
        end else begin
            if (second_byte_arrived) begin
                // On second byte arrival, output concatenated data next cycle
                data_out  <= {first_byte, data_in};
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0; // clear valid_out otherwise
            end
        end
    end

endmodule