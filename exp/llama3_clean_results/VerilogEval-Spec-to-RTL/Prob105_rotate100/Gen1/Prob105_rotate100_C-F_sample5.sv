module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

// Register to store the current state of the rotator
reg [99:0] q_reg;

// Always block to handle the rotation
always @(posedge clk) begin
    // If load is high, load the data into the rotator
    if (load) begin
        q_reg <= data;
    end else begin
        // Use a case statement to handle the rotation
        case (ena)
            2'b01: begin // Rotate right by one bit
                q_reg <= {q_reg[0], q_reg[99:1]};
            end
            2'b10: begin // Rotate left by one bit
                q_reg <= {q_reg[98:0], q_reg[99]};
            end
            default: begin // Do not rotate
                q_reg <= q_reg;
            end
        endcase
    end
end

// Assign the output of the rotator to q
assign q = q_reg;

endmodule