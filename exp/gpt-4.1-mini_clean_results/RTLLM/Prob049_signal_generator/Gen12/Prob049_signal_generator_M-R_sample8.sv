module signal_generator (
    input            clk,
    input            rst_n,
    output reg [4:0] wave
);

    reg state;         // 0: increment, 1: decrement
    reg next_state;
    reg [4:0] next_wave;

    // Next state and next wave calculation (combinational)
    always @(*) begin
        next_state = state;
        next_wave  = wave;

        if (state == 1'b0) begin // increment mode
            if (wave == 5'd31) begin
                next_state = 1'b1; // switch to decrement
                // wave stays at 31 this cycle
            end else begin
                next_wave = wave + 5'd1;
            end
        end else begin // decrement mode
            if (wave == 5'd0) begin
                next_state = 1'b0; // switch to increment
                // wave stays at 0 this cycle
            end else begin
                next_wave = wave - 5'd1;
            end
        end
    end

    // Sequential update of state and wave
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