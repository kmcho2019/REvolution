module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Split q into two halves for manipulation
    reg [49:0] lower;
    reg [49:0] upper;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            lower <= data[49:0];
            upper <= data[99:50];
        end else begin
            case (ena)
                2'b01: begin  // Rotate right by 1
                    // The LSB of q (bit 0) moves to q[99]
                    // Shift lower right by 1, inserting upper LSB at MSB
                    lower <= {upper[0], lower[49:1]};
                    // Shift upper right by 1, inserting lower LSB at MSB
                    upper <= {lower[0], upper[49:1]};
                    // Recombine q
                    q <= {upper, lower};
                end
                2'b10: begin  // Rotate left by 1
                    // The MSB of q (bit 99) moves to q[0]
                    // Shift lower left by 1, inserting upper MSB at LSB
                    lower <= {lower[48:0], upper[49]};
                    // Shift upper left by 1, inserting lower MSB at LSB
                    upper <= {upper[48:0], lower[49]};
                    // Recombine q
                    q <= {upper, lower};
                end
                default: begin
                    // Hold state, no rotation
                    q <= q;
                    lower <= lower;
                    upper <= upper;
                end
            endcase
        end
    end

endmodule