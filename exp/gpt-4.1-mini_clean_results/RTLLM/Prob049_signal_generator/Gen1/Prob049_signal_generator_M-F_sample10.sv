module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg state;  // 0: incrementing, 1: decrementing
    reg [4:0] next_wave;

    always @(*) begin
        case (state)
            1'b0: next_wave = wave + 5'd1;
            1'b1: next_wave = wave - 5'd1;
            default: next_wave = 5'd0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave  <= 5'd0;
        end else begin
            wave <= next_wave;

            case (state)
                1'b0: if (next_wave == 5'd31)
                          state <= 1'b1;
                1'b1: if (next_wave == 5'd0)
                          state <= 1'b0;
            endcase
        end
    end

endmodule