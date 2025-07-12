module signal_generator (
    input            clk,
    input            rst_n,
    output reg [4:0] wave
);

    reg state;          // 0: increment, 1: decrement
    reg [4:0] next_wave;
    reg next_state;

    // Combinational logic: calculate next wave and next state
    always @(*) begin
        if (state == 1'b0) begin // increment
            if (wave == 5'd31) begin
                next_state = 1'b1;   // switch to decrement
                next_wave  = wave - 5'd1; // start decrementing immediately
            end else begin
                next_state = state;
                next_wave  = wave + 5'd1;
            end
        end else begin // decrement
            if (wave == 5'd0) begin
                next_state = 1'b0;   // switch to increment
                next_wave  = wave + 5'd1; // start incrementing immediately
            end else begin
                next_state = state;
                next_wave  = wave - 5'd1;
            end
        end
    end

    // Sequential logic: update state and wave registers
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