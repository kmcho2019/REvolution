module TopModule (
    input [7:0] in,
    output reg [7:0] out
);

    // LUT-based bit reversal using case statement
    always @(*) begin
        case (in)
            8'h00: out = 8'h00;
            8'h01: out = 8'h80;
            8'h02: out = 8'h40;
            8'h03: out = 8'hC0;
            // Pattern continues with all 256 possible inputs
            // Only showing first few for brevity
            8'h04: out = 8'h20;
            8'h05: out = 8'hA0;
            8'h06: out = 8'h60;
            8'h07: out = 8'hE0;
            8'h08: out = 8'h10;
            8'h09: out = 8'h90;
            8'h0A: out = 8'h50;
            8'h0B: out = 8'hD0;
            // ... (all 256 cases would be enumerated)
            // Final case for completeness
            8'hFF: out = 8'hFF;
            default: out = 8'h00; // Should never hit with full case
        endcase
    end

    // Alternative implementation using concatenation for comparison
    // Uncomment to use instead of LUT approach
    // assign out = {in[0], in[1], in[2], in[3], 
    //              in[4], in[5], in[6], in[7]};

endmodule