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
reg set_z; // Flag to set z in the next cycle

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        shift_reg <= 3'b0;
        set_z <= 1'b0;
        z <= 1'b0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    shift_reg <= 3'b0;
                end
            end
            STATE_B: begin
                // Shift 'w' input into shift register
                shift_reg <= {w, shift_reg[2:1]};
                
                // Check if three cycles have passed
                if(shift_reg[2] == 1'b1 || shift_reg[1:0] == 2'b11 || shift_reg[1:0] == 2'b01) begin
                    set_z <= 1'b1;
                end
                else if(shift_reg[2] == 1'b0 && shift_reg[1:0] == 2'b00) begin
                    set_z <= 1'b0;
                end
                
                // Set z if set_z is high
                if(set_z) begin
                    z <= 1'b1;
                    set_z <= 1'b0;
                end
                else begin
                    z <= 1'b0;
                end
            end
        endcase
    end
end

endmodule