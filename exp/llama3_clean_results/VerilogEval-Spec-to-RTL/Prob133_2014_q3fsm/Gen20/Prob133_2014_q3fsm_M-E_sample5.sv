module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 1'b0;
localparam STATE_B = 1'b1;

reg state; // Current state
reg [2:0] shift_reg; // 3-bit shift register to store the last three 'w' values

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        shift_reg <= 3'b000;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                end
            end
            STATE_B: begin
                shift_reg <= {w, shift_reg[2:1]}; // Shift the bits one position to the right and insert the new 'w' value
                if(shift_reg == 3'b110 || shift_reg == 3'b101 || shift_reg == 3'b011) begin // Check if exactly two bits in the shift register are '1'
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule