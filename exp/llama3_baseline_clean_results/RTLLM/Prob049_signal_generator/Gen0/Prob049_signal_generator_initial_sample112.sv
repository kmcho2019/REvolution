module signal_generator (
    input           clk, 
    input           rst_n, 
    output reg [4:0] wave
);

reg [0:0] state; // state register (0: incrementing, 1: decrementing)

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        state <= 0;
        wave  <= 0;
    end else begin
        case (state)
            0: begin // incrementing state
                if (wave == 5'd31) begin // waveform reaches 31
                    state <= 1;
                    wave  <= 5'd31;
                end else begin
                    wave  <= wave + 1;
                end
            end
            1: begin // decrementing state
                if (wave == 5'd0) begin // waveform reaches 0
                    state <= 0;
                    wave  <= 5'd0;
                end else begin
                    wave  <= wave - 1;
                end
            end
            default: begin
                state <= 0;
                wave  <= 0;
            end
        endcase
    end
end

endmodule