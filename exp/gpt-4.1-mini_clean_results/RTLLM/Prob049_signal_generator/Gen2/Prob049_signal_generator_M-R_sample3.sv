module signal_generator (
    input  wire        clk,
    input  wire        rst_n,
    output reg  [4:0]  wave
);

    reg state; // 0: increment, 1: decrement
    reg next_state;
    reg [4:0] next_wave;

    // Combinational logic to determine next state and next wave value
    always @(*) begin
        // Default assignments
        next_state = state;
        next_wave  = wave;

        case (state)
            1'b0: begin // Incrementing
                next_wave = wave + 5'd1;
                if (wave == 5'd31)
                    next_state = 1'b1;
            end
            1'b1: begin // Decrementing
                next_wave = wave - 5'd1;
                if (wave == 5'd0)
                    next_state = 1'b0;
            end
        endcase
    end

    // Sequential logic to update state and wave at clock edge or reset
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