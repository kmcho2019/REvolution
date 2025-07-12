module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state;
reg [2:0] w_count;
reg [1:0] count;
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // state A
        w_count <= 3'b000;
        count <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01; // state B
                    count <= 2'b01;
                end
            end
            2'b01: begin // state B
                w_count <= {w_count[1:0], w};
                count <= count + 1'b1;
                if (count == 2'b11) begin
                    if (w_count == 3'b011 || w_count == 3'b101 || w_count == 3'b110) begin
                        z_reg <= 1'b1;
                    end else begin
                        z_reg <= 1'b0;
                    end
                    state <= 2'b01;
                    count <= 2'b01;
                    w_count <= 3'b000;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule