module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [2:0] w_shift; // 3-bit shift register to store w values
reg [1:0] state; // Current state (0: waiting for s, 1: examining w)
reg z_reg; // Output z

assign z = z_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_shift <= 0;
        z_reg <= 0;
    end
    else begin
        case(state)
            0: begin
                // Transition from state 0 to state 1 when s = 1
                if(s) begin
                    state <= 1;
                    w_shift <= {w, 2'b00}; // Initialize w_shift with w
                end
            end
            1: begin
                // Shift w_shift and append new w value
                w_shift <= {w, w_shift[2:1]};
                // Check if three cycles have passed
                if(w_shift[2:0] == 3'b110 || w_shift[2:0] == 3'b101 || w_shift[2:0] == 3'b011) begin
                    state <= 0;
                    z_reg <= 1;
                end
                else begin
                    state <= 0;
                    z_reg <= 0;
                end
            end
        endcase
    end
end

endmodule