module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;           // 0: increment, 1: decrement
    reg [4:0] next_wave;

    // Combinational logic to determine next_wave based on state and current wave
    always @(*) begin
        if (state == 1'b0) begin  // Incrementing
            next_wave = (wave == 5'd31) ? wave : wave + 5'd1;
        end else begin            // Decrementing
            next_wave = (wave == 5'd0) ? wave : wave - 5'd1;
        end
    end

    // Sequential logic for wave and state update with async reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;       // Start by incrementing
        end else begin
            wave <= next_wave;

            // Toggle direction state only when wave reaches bounds
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule