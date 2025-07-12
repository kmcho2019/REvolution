module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg state; // Current state (0: waiting for s, 1: examining w)
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
        if(state == 0) begin
            if(s) begin
                state <= 1;
            end
        end
        else begin
            state <= 1;
        end
    end
end

always @(posedge clk) begin
    if(reset) begin
        w_reg <= 0;
    end
    else begin
        if(state == 1) begin
            w_reg <= {w, w_reg[2:1]};
        end
    end
end

assign z_reg = (state == 1) && (w_reg == 3'b110 || w_reg == 3'b101 || w_reg == 3'b011);

endmodule