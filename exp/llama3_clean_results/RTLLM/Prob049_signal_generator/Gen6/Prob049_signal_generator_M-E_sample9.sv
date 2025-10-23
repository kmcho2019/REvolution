module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] lfsr;
reg [4:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        lfsr <= 1; // Initialize LFSR with a non-zero value
        counter <= 0;
    end else begin
        // Update LFSR
        lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[0]};
        
        // Update counter based on LFSR's most significant bit
        if (lfsr[4] == 1) begin
            counter <= (counter + 1) % 32; // Modulo 32 to cycle between 0 and 31
        end else begin
            counter <= (counter - 1 + 32) % 32; // Decrement with wrap-around
        end
    end
end

assign wave = counter;

endmodule