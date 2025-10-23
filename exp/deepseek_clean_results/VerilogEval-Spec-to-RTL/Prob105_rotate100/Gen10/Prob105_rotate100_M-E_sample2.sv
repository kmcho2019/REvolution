module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Internal signals for slice boundaries
reg [24:0] slice0, slice1, slice2, slice3;
reg cross_bit_right, cross_bit_left;

always @(posedge clk) begin
    if (load) begin
        // Load all slices synchronously
        slice0 <= data[24:0];
        slice1 <= data[49:25];
        slice2 <= data[74:50];
        slice3 <= data[99:75];
    end else begin
        case (ena)
            2'b01: begin  // Right rotate
                // Stage 1: Rotate within each slice
                slice0 <= {slice0[0], slice0[24:1]};
                slice1 <= {slice1[0], slice1[24:1]};
                slice2 <= {slice2[0], slice2[24:1]};
                slice3 <= {slice3[0], slice3[24:1]};
                
                // Stage 2: Handle cross-slice bits (pipelined)
                cross_bit_right <= slice0[0];  // Capture LSB of slice0
                slice0[24] <= slice1[0];      // Transfer slice1 LSB to slice0 MSB
                slice1[24] <= slice2[0];       // Transfer slice2 LSB to slice1 MSB
                slice2[24] <= slice3[0];       // Transfer slice3 LSB to slice2 MSB
                slice3[24] <= cross_bit_right; // Complete the rotation
            end
            
            2'b10: begin  // Left rotate
                // Stage 1: Rotate within each slice
                slice0 <= {slice0[23:0], slice0[24]};
                slice1 <= {slice1[23:0], slice1[24]};
                slice2 <= {slice2[23:0], slice2[24]};
                slice3 <= {slice3[23:0], slice3[24]};
                
                // Stage 2: Handle cross-slice bits (pipelined)
                cross_bit_left <= slice3[24];   // Capture MSB of slice3
                slice3[0] <= slice2[24];       // Transfer slice2 MSB to slice3 LSB
                slice2[0] <= slice1[24];       // Transfer slice1 MSB to slice2 LSB
                slice1[0] <= slice0[24];       // Transfer slice0 MSB to slice1 LSB
                slice0[0] <= cross_bit_left;   // Complete the rotation
            end
            
            default: begin // No rotation
                // All slices maintain their values
            end
        endcase
    end
end

// Combine slices to form output
assign q = {slice3, slice2, slice1, slice0};

endmodule