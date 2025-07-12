module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg next_z;

always @ (posedge clk) begin
    case (y)
        3'b000: begin
            current_state <= x ? 3'b001 : 3'b000;
            next_z <= 0;
        end
        3'b001: begin
            current_state <= x ? 3'b100 : 3'b001;
            next_z <= 0;
        end
        3'b010: begin
            current_state <= x ? 3'b001 : 3'b010;
            next_z <= 0;
        end
        3'b011: begin
            current_state <= x ? 3'b010 : 3'b001;
            next_z <= 1;
        end
        3'b100: begin
            current_state <= x ? 3'b100 : 3'b011;
            next_z <= 1;
        end
        default: begin
            current_state <= 3'b000;
            next_z <= 0;
        end
    endcase
end

assign Y0 = current_state[0];
assign z = next_z;

endmodule