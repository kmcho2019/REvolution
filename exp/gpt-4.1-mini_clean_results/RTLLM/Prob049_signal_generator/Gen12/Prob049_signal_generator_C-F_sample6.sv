module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement
    reg [4:0] next_wave;

    always @(*) begin
        if (state == 1'b0) begin // incrementing
            if (wave == 5'd31)
                next_wave = wave; // hold at max, will toggle state next cycle
            else
                next_wave = wave + 5'd1;
        end else begin // decrementing
            if (wave == 5'd0)
                next_wave = wave; // hold at min, will toggle state next cycle
            else
                next_wave = wave - 5'd1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start by incrementing
        end else begin
            wave <= next_wave;

            // Toggle state only when wave reached boundary and held
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule