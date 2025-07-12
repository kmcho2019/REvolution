module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;
    reg next_state;
    reg [4:0] next_wave;

    // Next state and wave combinational logic
    always @(*) begin
        case(state)
            1'b0: begin // increment
                if (wave == 5'd31) begin
                    next_state = 1'b1;
                    next_wave  = wave;  // hold wave on boundary
                end else begin
                    next_state = 1'b0;
                    next_wave  = wave + 5'd1;
                end
            end
            1'b1: begin // decrement
                if (wave == 5'd0) begin
                    next_state = 1'b0;
                    next_wave  = wave;  // hold wave on boundary
                end else begin
                    next_state = 1'b1;
                    next_wave  = wave - 5'd1;
                end
            end
            default: begin
                next_state = 1'b0;
                next_wave = 5'd0;
            end
        endcase
    end

    // State register update
    reg state;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave <= 5'd0;
        end else begin
            state <= next_state;
            wave <= next_wave;
        end
    end

endmodule