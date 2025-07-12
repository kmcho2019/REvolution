module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define the states
enum logic [2:0] {
    IDLE,
    START_RECEIVED,
    DATA_COLLECTION,
    STOP_BIT_VERIFICATION,
    DONE_STATE
} state, next_state;

// Internal registers
logic [7:0] data_reg;
logic [2:0] bit_counter;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_reg <= 8'b0;
        bit_counter <= 3'b0;
        out_byte <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= START_RECEIVED;
                end else begin
                    state <= IDLE;
                end
            end
            START_RECEIVED: begin
                state <= DATA_COLLECTION;
                bit_counter <= 3'b1;
            end
            DATA_COLLECTION: begin
                data_reg[7 - bit_counter] <= in;
                if (bit_counter == 8) begin
                    state <= STOP_BIT_VERIFICATION;
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
            STOP_BIT_VERIFICATION: begin
                if (in) begin // Stop bit detected
                    state <= DONE_STATE;
                end else begin
                    state <= STOP_BIT_VERIFICATION;
                end
            end
            DONE_STATE: begin
                out_byte <= data_reg;
                done <= 1'b1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Reset done signal on the next clock cycle after asserting it
always_comb begin
    if (state == DONE_STATE) begin
        done = 1'b1;
    end else begin
        done = 1'b0;
    end
end

endmodule