module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {IDLE = 1'b0, FULL = 1'b1} state_t;
    reg [7:0] data_lock;
    reg valid_out_next;
    state_t state, state_next;

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_lock <= 8'd0;
            data_out <= 16'd0;
            valid_out <= 1'b0;
        end else begin
            state <= state_next;
            valid_out <= valid_out_next;
            if (state == IDLE && valid_in) begin
                data_lock <= data_in; // Store first data
            end
            if (state == FULL && valid_in) begin
                data_out <= {data_lock, data_in}; // Concatenate on second data input
            end
        end
    end

    // FSM next state and valid_out logic
    always @(*) begin
        // Default assignments
        state_next = state;
        valid_out_next = 1'b0;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    state_next = FULL;
                end
            end
            FULL: begin
                if (valid_in) begin
                    valid_out_next = 1'b1; // Output valid after second input
                    state_next = IDLE;     // Return to idle for next pair
                end
            end
            default: begin
                state_next = IDLE;
            end
        endcase
    end

endmodule