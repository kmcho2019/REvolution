module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01
    } state_t;

    state_t state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] cnt;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and data handling
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            IDLE: begin
                if (din_valid)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (cnt == 4'd8)
                    next_state = IDLE;
            end
        endcase
    end

    // Data and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output

            case(state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    cnt       <= 4'd0;
                    if (din_valid) begin
                        // Start collecting bits
                        shift_reg <= {din_serial, 7'd0};
                        cnt <= 4'd1;
                    end
                end

                SHIFT: begin
                    if (din_valid) begin
                        shift_reg <= {shift_reg[6:0], din_serial};
                        cnt <= cnt + 1;
                    end
                    if (cnt == 4'd8) begin
                        dout_parallel <= shift_reg;
                        dout_valid <= 1'b1;
                        // After output, remain in SHIFT for next data or transition happens next cycle
                    end
                end
            endcase
        end
    end

endmodule