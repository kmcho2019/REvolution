module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        STOP,
        ERROR
    } state_t;

    // Internal signals
    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg done_reg;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 1'b0;
                    if (in == 1'b0) begin  // Start bit detected
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                    end
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // Shift in LSB first
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin  // Valid stop bit
                        state <= IDLE;
                        done_reg <= 1'b1;
                    end else begin  // Missing stop bit
                        state <= ERROR;
                    end
                end

                ERROR: begin
                    if (in == 1'b1) begin  // Found stop bit
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule