module signal_generator (
    input clk, 
    input rst_n, 
    output [4:0] wave
);

reg [0:0] state; // state register
reg [4:0] wave_reg; // wave register

assign wave = wave_reg; // continuous assignment to output port

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // clear state register to 0
        wave_reg <= 0; // clear wave register to 0
    end else begin // normal operation
        case (state)
            0: begin // increment waveform
                wave_reg <= wave_reg + 1;
                if (wave_reg == 31) begin // transition to decrement state
                    state <= 1;
                end
            end
            1: begin // decrement waveform
                wave_reg <= wave_reg - 1;
                if (wave_reg == 0) begin // transition to increment state
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule