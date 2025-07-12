module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;  // Internal register to hold the shift operation result
reg [2:0] state;  // State machine to control the shifting process

// Initialize the internal register and state machine
initial
begin
    q_reg = 8'd0;
    state = 3'd0;
end

// Update the internal register and state machine on each rising edge of the clock
always @ (posedge clk)
begin
    case (state)
        3'd0: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = 1'b0;
            state <= 3'd1;
        end
        3'd1: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = q_reg[1];
            state <= 3'd2;
        end
        3'd2: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = q_reg[2];
            state <= 3'd3;
        end
        3'd3: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = q_reg[3];
            state <= 3'd4;
        end
        3'd4: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = q_reg[4];
            state <= 3'd5;
        end
        3'd5: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = q_reg[5];
            state <= 3'd6;
        end
        3'd6: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = q_reg[6];
            state <= 3'd7;
        end
        3'd7: begin
            q_reg[7:1] = q_reg[6:0];
            q_reg[0] = d;
            state <= 3'd0;
        end
    endcase
end

// Assign the internal register to the output
assign q = q_reg;

endmodule