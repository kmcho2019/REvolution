module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State encoding using localparam for clarity
    localparam INCREMENT = 1'b0;
    localparam DECREMENT = 1'b1;

    reg state, next_state;
    reg [4:0] next_wave;

    // Combinational logic to determine next state and next wave value
    always @(*) begin
        next_state = state;
        next_wave = wave;

        case (state)
            INCREMENT: begin
                if (wave == 5'd31) begin
                    next_state = DECREMENT;
                    next_wave = wave; // hold at max before decrementing
                end else begin
                    next_wave = wave + 1;
                end
            end
            DECREMENT: begin
                if (wave == 5'd0) begin
                    next_state = INCREMENT;
                    next_wave = wave; // hold at min before incrementing
                end else begin
                    next_wave = wave - 1;
                end
            end
            default: begin
                next_state = INCREMENT;
                next_wave = 5'd0;
            end
        endcase
    end

    // Sequential logic: update state and wave registers on clock edge or reset asynchronously
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= INCREMENT;
            wave <= 5'd0;
        end else begin
            state <= next_state;
            wave <= next_wave;
        end
    end

endmodule