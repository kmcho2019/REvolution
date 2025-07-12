module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: incrementing, 1: decrementing

    reg [4:0] next_wave;
    reg       next_state;

    // Combinational logic for next state and wave calculation
    always @(*) begin
        case (state)
            1'b0: begin
                next_wave = wave + 1'b1;
                if (next_wave == 5'd31)
                    next_state = 1'b1;
                else
                    next_state = state;
            end
            1'b1: begin
                next_wave = wave - 1'b1;
                if (next_wave == 5'd0)
                    next_state = 1'b0;
                else
                    next_state = state;
            end
            default: begin
                next_wave  = 5'b0;
                next_state = 1'b0;
            end
        endcase
    end

    // Sequential logic for updating registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 1'b0;
            wave  <= 5'b0;
        end else begin
            state <= next_state;
            wave  <= next_wave;
        end
    end

endmodule