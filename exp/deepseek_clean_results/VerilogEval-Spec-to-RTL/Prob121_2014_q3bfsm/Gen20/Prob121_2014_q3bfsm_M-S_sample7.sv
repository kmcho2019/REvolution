module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    reg z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z_reg <= 1'b0;
        end
        else begin
            case (state)
                3'b000: begin
                    state <= x ? 3'b001 : 3'b000;
                    z_reg <= 1'b0;
                end
                3'b001: begin
                    state <= x ? 3'b100 : 3'b001;
                    z_reg <= 1'b0;
                end
                3'b010: begin
                    state <= x ? 3'b001 : 3'b010;
                    z_reg <= 1'b0;
                end
                3'b011: begin
                    state <= x ? 3'b010 : 3'b001;
                    z_reg <= 1'b1;
                end
                3'b100: begin
                    state <= x ? 3'b100 : 3'b011;
                    z_reg <= 1'b1;
                end
            endcase
        end
    end

    assign z = z_reg;

endmodule