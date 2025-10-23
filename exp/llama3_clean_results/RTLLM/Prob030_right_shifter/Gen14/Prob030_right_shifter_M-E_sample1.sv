module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [2:0] counter;  // Counter to keep track of the current position
reg [7:0] q_reg;  // Internal shift register

initial begin
    counter = 3'd0;  // Initialize counter to 0
    q_reg = 8'd0;  // Initialize q_reg to 0
end

always @(posedge clk) begin
    counter <= counter + 1;  // Increment counter
    case (counter)
        3'd0: q_reg[7] <= d;  // Insert new input bit at most significant position
        3'd1: begin
            q_reg[7] <= q_reg[6];  // Shift bits to the right
            q_reg[6] <= d;
        end
        3'd2: begin
            q_reg[7] <= q_reg[5];  // Shift bits to the right
            q_reg[6] <= q_reg[5];
            q_reg[5] <= d;
        end
        3'd3: begin
            q_reg[7] <= q_reg[4];  // Shift bits to the right
            q_reg[6] <= q_reg[5];
            q_reg[5] <= q_reg[4];
            q_reg[4] <= d;
        end
        3'd4: begin
            q_reg[7] <= q_reg[3];  // Shift bits to the right
            q_reg[6] <= q_reg[5];
            q_reg[5] <= q_reg[4];
            q_reg[4] <= q_reg[3];
            q_reg[3] <= d;
        end
        3'd5: begin
            q_reg[7] <= q_reg[2];  // Shift bits to the right
            q_reg[6] <= q_reg[5];
            q_reg[5] <= q_reg[4];
            q_reg[4] <= q_reg[3];
            q_reg[3] <= q_reg[2];
            q_reg[2] <= d;
        end
        3'd6: begin
            q_reg[7] <= q_reg[1];  // Shift bits to the right
            q_reg[6] <= q_reg[5];
            q_reg[5] <= q_reg[4];
            q_reg[4] <= q_reg[3];
            q_reg[3] <= q_reg[2];
            q_reg[2] <= q_reg[1];
            q_reg[1] <= d;
        end
        3'd7: begin
            q_reg[7] <= q_reg[0];  // Shift bits to the right
            q_reg[6] <= q_reg[5];
            q_reg[5] <= q_reg[4];
            q_reg[4] <= q_reg[3];
            q_reg[3] <= q_reg[2];
            q_reg[2] <= q_reg[1];
            q_reg[1] <= q_reg[0];
            q_reg[0] <= d;
        end
    endcase
end

assign q = q_reg;  // Assign output

endmodule