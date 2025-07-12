module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state;
reg [2:0] w_count;
reg z_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00;
        w_count <= 3'b000;
        z_reg <= 1'b0;
    end else begin
        case(state)
            2'b00: begin
                if(s) begin
                    state <= 2'b01;
                    w_count <= 3'b001;
                    z_reg <= 1'b0;
                end else begin
                    state <= 2'b00;
                    w_count <= 3'b000;
                    z_reg <= 1'b0;
                end
            end
            2'b01: begin
                w_count <= {w_count[1:0], w};
                if(w_count == 3'b110 || w_count == 3'b101 || w_count == 3'b011) begin
                    state <= 2'b10;
                end else if(w_count[2:0] == 3'b111 || w_count[2:0] == 3'b000) begin
                    state <= 2'b01;
                end
            end
            2'b10: begin
                z_reg <= 1'b1;
                state <= 2'b01;
                w_count <= 3'b001;
            end
            default: begin
                state <= 2'b00;
                w_count <= 3'b000;
                z_reg <= 1'b0;
            end
        endcase
    end
end

assign z = z_reg;

endmodule