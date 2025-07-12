module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;
    wire [2:0] sel = {A, B, C};
    
    always @(posedge clk) begin
        if (enable) begin
            // Normal shift operation when writing
            Q <= {Q[6:0], S};
        end else begin
            // Circular rotation when reading (no write)
            case (sel)
                3'b000: Q <= Q;               // No rotation
                3'b001: Q <= {Q[0], Q[7:1]};  // Rotate right 1
                3'b010: Q <= {Q[1:0], Q[7:2]}; // Rotate right 2
                3'b011: Q <= {Q[2:0], Q[7:3]}; // Rotate right 3
                3'b100: Q <= {Q[3:0], Q[7:4]}; // Rotate right 4
                3'b101: Q <= {Q[4:0], Q[7:5]}; // Rotate right 5
                3'b110: Q <= {Q[5:0], Q[7:6]}; // Rotate right 6
                3'b111: Q <= {Q[6:0], Q[7]};   // Rotate right 7
            endcase
        end
    end
    
    assign Z = Q[0];  // Always output first bit after potential rotation
endmodule