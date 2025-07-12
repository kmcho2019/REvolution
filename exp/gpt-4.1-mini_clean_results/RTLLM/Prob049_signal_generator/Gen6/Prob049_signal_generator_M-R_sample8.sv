module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg state; // 0: increment, 1: decrement
    reg [4:0] wave_next;
    reg state_next;

    always @(*) begin
        // Default assignments
        wave_next = wave;
        state_next = state;

        case(state)
            1'b0: begin // increment state
                if (wave == 5'd31) begin
                    state_next = 1'b1; // switch to decrement
                    wave_next = wave - 5'd1; // start decrementing from 31
                end else begin
                    wave_next = wave + 5'd1;
                end
            end
            1'b1: begin // decrement state
                if (wave == 5'd0) begin
                    state_next = 1'b0; // switch to increment
                    wave_next = wave + 5'd1; // start incrementing from 0
                end else begin
                    wave_next = wave - 5'd1;
                end
            end
            default: begin
                state_next = 1'b0;
                wave_next = 5'd0;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            state <= 1'b0;
        end else begin
            wave <= wave_next;
            state <= state_next;
        end
    end

endmodule