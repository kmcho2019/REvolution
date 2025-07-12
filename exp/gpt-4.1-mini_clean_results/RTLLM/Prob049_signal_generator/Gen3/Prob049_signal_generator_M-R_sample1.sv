module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg state;           // current state: 0 = incrementing, 1 = decrementing
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic: determine next state and next wave based on current state and wave
    always @* begin
        case (state)
            1'b0: begin
                // Increment wave
                if (wave == 5'd31) begin
                    next_state = 1'b1;     // switch to decrementing
                    next_wave  = wave - 5'd1;
                end else begin
                    next_state = 1'b0;
                    next_wave  = wave + 5'd1;
                end
            end
            1'b1: begin
                // Decrement wave
                if (wave == 5'd0) begin
                    next_state = 1'b0;     // switch to incrementing
                    next_wave  = wave + 5'd1;
                end else begin
                    next_state = 1'b1;
                    next_wave  = wave - 5'd1;
                end
            end
            default: begin
                // Defensive: reset state and wave
                next_state = 1'b0;
                next_wave  = 5'd0;
            end
        endcase
    end

    // Sequential logic: update state and wave on clock edge or asynchronous reset
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