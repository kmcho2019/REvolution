module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        COLLECTING,
        OUTPUT_READY
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_counter;
    reg [7:0] shadow_reg;  // Temporary storage for collecting bits

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_counter <= 3'b0;
            shadow_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (din_valid) begin
                        shadow_reg <= {shadow_reg[6:0], din_serial};
                        bit_counter <= bit_counter + 1;
                    end
                end

                COLLECTING: begin
                    if (din_valid) begin
                        shadow_reg <= {shadow_reg[6:0], din_serial};
                        bit_counter <= bit_counter + 1;
                    end
                end

                OUTPUT_READY: begin
                    dout_parallel <= shadow_reg;
                    dout_valid <= 1'b1;
                    bit_counter <= 3'b0;
                    if (din_valid) begin
                        shadow_reg <= {7'b0, din_serial};
                        bit_counter <= 3'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (din_valid)
                    next_state = COLLECTING;
            end

            COLLECTING: begin
                if (bit_counter == 3'd7)
                    next_state = OUTPUT_READY;
            end

            OUTPUT_READY: begin
                next_state = (din_valid) ? COLLECTING : IDLE;
            end
        endcase
    end

    // Output valid is only active for one cycle
    always @(posedge clk) begin
        if (state != OUTPUT_READY)
            dout_valid <= 1'b0;
    end

endmodule