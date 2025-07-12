// Hybrid LFSR module with dynamic polynomial switching
module Hybrid_LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the Hybrid LFSR
);

// Internal signals for the two LFSR modules
reg [3:0] lfsr1;
reg [3:0] lfsr2;

// Control signal to switch between the two polynomials
reg switch;

// Sequential logic block to update the Hybrid LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize outputs to zero
        lfsr1 <= 4'b0;
        lfsr2 <= 4'b0;
        switch <= 1'b0;
    end else begin // Normal operation: update LFSR states and switch
        // Calculate feedback for the first LFSR (Fibonacci type)
        reg feedback1 = ~(lfsr1[3] ^ lfsr1[2]);
        lfsr1 <= {lfsr1[2:0], feedback1};
        
        // Calculate feedback for the second LFSR (Galois type)
        reg feedback2 = ~(lfsr2[3] ^ lfsr2[1]);
        lfsr2 <= {lfsr2[2:0], feedback2};
        
        // Switch between the two LFSR outputs every 16 clock cycles
        if (switch) begin
            out <= lfsr2;
        end else begin
            out <= lfsr1;
        end
        
        // Toggle the switch signal every 16 clock cycles
        if (lfsr1 == 4'b1111) begin
            switch <= ~switch;
        end
    end
end

endmodule