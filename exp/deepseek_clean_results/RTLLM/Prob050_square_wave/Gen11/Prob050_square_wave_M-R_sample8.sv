module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [6:0] count;
    reg state;  // 0=IDLE, 1=COUNT
    reg wave_reg;
    
    assign wave_out = wave_reg;
    
    always @(posedge clk) begin
        case (state)
            0: begin  // IDLE
                if (freq[7]) begin
                    state <= 1;
                    count <= freq[6:0];
                end
            end
            1: begin  // COUNT
                if (count == 0) begin
                    wave_reg <= ~wave_reg;
                    if (freq[7]) begin
                        count <= freq[6:0];
                    end else begin
                        state <= 0;
                    end
                end else begin
                    count <= count - 1;
                end
            end
        endcase
    end

endmodule