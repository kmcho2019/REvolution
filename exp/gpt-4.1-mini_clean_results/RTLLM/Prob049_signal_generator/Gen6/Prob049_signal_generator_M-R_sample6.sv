module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // Define states for clarity
    localparam INC = 1'b0;
    localparam DEC = 1'b1;

    reg state;
    reg next_state;
    reg [4:0] next_wave;

    // State transition logic (combinational)
    always @(*) begin
        next_state = state;
        case(state)
            INC: begin
                if (wave == 5'd31)
                    next_state = DEC;
            end
            DEC: begin
                if (wave == 5'd0)
                    next_state = INC;
            end
        endcase
    end

    // Wave update logic (combinational)
    always @(*) begin
        case(state)
            INC: next_wave = wave + 5'd1;
            DEC: next_wave = wave - 5'd1;
            default: next_wave = 5'd0;
        endcase
    end

    // Sequential update of state and wave
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= INC;
            wave <= 5'd0;
        end else begin
            state <= next_state;
            wave <= next_wave;
        end
    end

endmodule