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
reg [2:0] shift_reg; // Shift register to track last three 'w' inputs
reg [1:0] count; // Counter for '1's in shift register

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        shift_reg <= 3'b0;
        count <= 2'b0;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    shift_reg <= 3'b0;
                    count <= 2'b0;
                end
            end
            STATE_B: begin
                // Shift 'w' input into shift register
                shift_reg <= {w, shift_reg[2:1]};
                
                // Count '1's in shift register
                if(shift_reg[0] == 1'b1) begin
                    count <= count + 1'b1;
                end
                
                // Check if three cycles have passed
                if(shift_reg[2] == 1'b1) begin
                    // Check if exactly two '1's are in shift register
                    if(count == 2'b10) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    // Reset counter
                    count <= 2'b0;
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule