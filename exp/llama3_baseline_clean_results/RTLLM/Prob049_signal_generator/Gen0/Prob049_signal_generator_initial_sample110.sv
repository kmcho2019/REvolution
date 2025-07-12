module signal_generator (
    input  clk,
    input  rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;
reg       state_reg;
reg       state_next;
reg [4:0] wave_next;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= 1'b0;
        wave_reg  <= 5'b0;
    end else begin
        state_reg <= state_next;
        wave_reg  <= wave_next;
    end
end

always @(*) begin
    state_next = state_reg;
    wave_next  = wave_reg;
    
    case (state_reg)
        1'b0: begin
            wave_next = wave_reg + 1;
            if (wave_reg == 5'b11111) begin
                state_next = 1'b1;
            end
        end
        1'b1: begin
            wave_next = wave_reg - 1;
            if (wave_reg == 5'b0) begin
                state_next = 1'b0;
            end
        end
    endcase
end

assign wave = wave_reg;

endmodule