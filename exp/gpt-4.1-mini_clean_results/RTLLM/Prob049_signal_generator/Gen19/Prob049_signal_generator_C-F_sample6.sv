module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement
    reg [4:0] next_wave;

    always @(*) begin
        if (state == 1'b0) begin // increment
            if (wave == 5'd31)
                next_wave = wave; // saturate at max
            else
                next_wave = wave + 5'd1;
        end else begin // decrement
            if (wave == 5'd0)
                next_wave = wave; // saturate at min
            else
                next_wave = wave - 5'd1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start by incrementing
        end else begin
            wave <= next_wave;

            // Toggle state only when wave reaches boundary after update
            if ((state == 1'b0 && next_wave == 5'd31) || 
                (state == 1'b1 && next_wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule