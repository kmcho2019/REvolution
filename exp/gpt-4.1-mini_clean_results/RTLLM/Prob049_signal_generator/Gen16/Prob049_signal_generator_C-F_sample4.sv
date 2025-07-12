module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State: 0 = increment, 1 = decrement
    reg state;
    reg [4:0] next_wave;

    // Combinational logic for next_wave based on state and wave
    always @(*) begin
        if (state == 1'b0) begin // increment mode
            if (wave == 5'd31)
                next_wave = wave; // hold at max
            else
                next_wave = wave + 5'd1;
        end else begin // decrement mode
            if (wave == 5'd0)
                next_wave = wave; // hold at min
            else
                next_wave = wave - 5'd1;
        end
    end

    // Sequential logic updates wave and state synchronously with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start by incrementing
        end else begin
            wave <= next_wave;

            // Toggle state only when wave is held at boundaries
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule