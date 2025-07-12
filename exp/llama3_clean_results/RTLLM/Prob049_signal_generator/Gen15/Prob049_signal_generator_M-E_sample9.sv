module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] lfsr;
reg [4:0] wave_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        lfsr <= 1; // Initialize LFSR with a non-zero value
        wave_reg <= 0;
    end else begin
        // LFSR update
        lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[3]};
        
        // Mapping LFSR output to triangle wave
        if (lfsr[4] == 1) begin
            wave_reg <= wave_reg - 1;
        end else begin
            wave_reg <= wave_reg + 1;
        end
        
        // Boundary conditions for triangle wave
        if (wave_reg == 31) begin
            wave_reg <= 31;
        end else if (wave_reg == 0) begin
            wave_reg <= 0;
        end
    end
end

assign wave = wave_reg;

endmodule