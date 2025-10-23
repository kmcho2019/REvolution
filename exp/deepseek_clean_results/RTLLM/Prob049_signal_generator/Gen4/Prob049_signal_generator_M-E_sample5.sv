module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // Extra bit for overflow detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 6'b0;
    end
    else begin
        // Continuous counting - direction auto-reverses at boundaries
        if (counter[5] || (&counter[4:0])) begin  // If overflow or at 31
            counter <= counter - 1;  // Start counting down
        end
        else if (~|counter[4:0]) begin  // If at 0
            counter <= counter + 1;  // Start counting up
        end
        else begin
            counter <= counter + (counter[5] ? -1 : 1);  // Continue current direction
        end
        
        wave <= counter[4:0];  // Output the 5-bit waveform
    end
end

endmodule