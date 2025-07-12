module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg       state;        // Current state: 0 = increment, 1 = decrement
    reg       next_state;   // Next state
    reg [4:0] next_wave;    // Next wave value

    // Combinational logic for next state and next wave
    always @(*) begin
        case(state)
            1'b0: begin // increment state
                if (wave == 5'd31) begin
                    next_state = 1'b1;
                    next_wave  = wave - 1;
                end else begin
                    next_state = state;
                    next_wave  = wave + 1;
                end
            end
            1'b1: begin // decrement state
                if (wave == 5'd0) begin
                    next_state = 1'b0;
                    next_wave  = wave + 1;
                end else begin
                    next_state = state;
                    next_wave  = wave - 1;
                end
            end
            default: begin
                next_state = 1'b0;
                next_wave  = 5'd0;
            end
        endcase
    end

    // Sequential logic for state and wave update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave  <= 5'd0;
        end else begin
            state <= next_state;
            wave  <= next_wave;
        end
    end

endmodule