module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [2:0] w_reg; // Shift register to store 'w' values
reg [1:0] state; // Current state (0: waiting for s, 1: examining w)
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
                else begin
                    state <= 0;
                    w_reg <= w_reg;
                end
            end
            1: begin
                // Shift 'w' value into the shift register
                w_reg <= {w, w_reg[2:1]};
                // Stay in state 1
                state <= 1;
            end
        endcase
    end
end

// Combinational logic to generate output 'z'
assign z_reg = (state == 1) && ((w_reg == 3'b110) || (w_reg == 3'b101) || (w_reg == 3'b011));

endmodule