module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // Current state (0: waiting for s, 1: examining w)
reg [2:0] w_reg; // Shift register to store 'w' values
reg z_reg; // Output z

assign z = z_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_reg <= 0;
        z_reg <= 0;
    end
    else begin
        case(state)
            0: begin
                // Transition from state 0 to state 1 when s = 1
                if(s) begin
                    state <= 1;
                    w_reg <= {w, 2'b00};
                end
            end
            1: begin
                // Shift 'w' value into the shift register
                w_reg <= {w, w_reg[2:1]};
                // Check if three cycles have passed and set 'z' accordingly
                if(w_reg == 3'b001 || w_reg == 3'b010 || w_reg == 3'b100 || w_reg == 3'b011 || w_reg == 3'b101 || w_reg == 3'b110) begin
                    z_reg <= 1;
                end
                else begin
                    z_reg <= 0;
                end
            end
        endcase
    end
end

endmodule