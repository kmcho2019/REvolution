module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg state;  // 1'b1 means we've seen "10" and waiting for '1'

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 1'b0;
        end else begin
            state <= (state & x) | (~state & x & ~shift_reg);
        end
    end

    reg shift_reg;  // Stores previous bit
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 1'b0;
        end else begin
            shift_reg <= x;
        end
    end

    assign z = state & x;

endmodule