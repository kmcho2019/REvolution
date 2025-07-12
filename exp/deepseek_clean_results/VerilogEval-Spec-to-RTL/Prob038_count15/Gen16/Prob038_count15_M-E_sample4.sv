module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] lfsr;
wire lfsr_feedback;
wire [3:0] binary_count;

// LFSR feedback (Galois configuration)
assign lfsr_feedback = lfsr[3];

// Binary decoder (converts LFSR state to binary count)
assign binary_count = 
    (lfsr == 4'b0001) ? 4'b0000 :
    (lfsr == 4'b0010) ? 4'b0001 :
    (lfsr == 4'b0100) ? 4'b0010 :
    (lfsr == 4'b1000) ? 4'b0011 :
    (lfsr == 4'b0011) ? 4'b0100 :
    (lfsr == 4'b0110) ? 4'b0101 :
    (lfsr == 4'b1100) ? 4'b0110 :
    (lfsr == 4'b1011) ? 4'b0111 :
    (lfsr == 4'b0101) ? 4'b1000 :
    (lfsr == 4'b1010) ? 4'b1001 :
    (lfsr == 4'b0111) ? 4'b1010 :
    (lfsr == 4'b1110) ? 4'b1011 :
    (lfsr == 4'b1111) ? 4'b1100 :
    (lfsr == 4'b1101) ? 4'b1101 :
    (lfsr == 4'b1001) ? 4'b1110 :
    4'b1111; // lfsr == 4'b0000

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0001;
        q <= 4'b0000;
    end
    else begin
        // Update LFSR
        lfsr <= {lfsr[2:0], lfsr_feedback} ^ (lfsr[3] ? 4'b1000 : 4'b0000);
        
        // Output binary count
        q <= binary_count;
    end
end

endmodule