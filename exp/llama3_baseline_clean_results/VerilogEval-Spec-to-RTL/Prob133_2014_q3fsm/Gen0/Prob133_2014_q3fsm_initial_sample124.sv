module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // state A = 2'b00, state B = 2'b01, state C1 = 2'b10, state C2 = 2'b11
reg [1:0] count; // count the number of w = 1
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        count <= 2'b00;
        z_reg <= 1'b0;
    end
    else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin // state B
                state <= 2'b10;
                count <= w ? 1'b1 : 1'b0;
            end
            2'b10: begin // state C1
                state <= 2'b11;
                count <= count + (w ? 1'b1 : 1'b0);
            end
            2'b11: begin // state C2
                state <= 2'b10;
                count <= count + (w ? 1'b1 : 1'b0);
                if (count == 2'b10) begin // count is 2
                    z_reg <= 1'b1;
                end
                else begin
                    z_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule