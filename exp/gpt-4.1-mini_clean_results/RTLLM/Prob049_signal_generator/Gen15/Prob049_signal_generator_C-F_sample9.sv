module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;           // 0: increment, 1: decrement
    reg [4:0] next_wave;

    // Combinational logic to determine next wave value based on current state and wave
    always @(*) begin
        case (state)
            1'b0: // increment mode
                next_wave = (wave == 5'd31) ? wave : wave + 5'd1;
            1'b1: // decrement mode
                next_wave = (wave == 5'd0) ? wave : wave - 5'd1;
            default:
                next_wave = wave; // safe fallback
        endcase
    end

    // Sequential logic for wave and state update with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start incrementing
        end else begin
            wave <= next_wave;

            // Toggle direction state only when wave has reached boundary and held there
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0))
                state <= ~state;
        end
    end

endmodule