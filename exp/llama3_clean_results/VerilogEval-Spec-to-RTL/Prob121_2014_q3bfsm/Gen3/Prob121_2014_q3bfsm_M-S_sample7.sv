module TopModule(
    input  clk,
    input  reset,
    input  x,
    output reg z
);

reg [2:0] current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000;
        z <= 0;
    end else begin
        case (current_state)
            3'b000: begin
                current_state <= (x == 0) ? 3'b000 : 3'b001;
                z <= 0;
            end
            3'b001: begin
                current_state <= (x == 0) ? 3'b001 : 3'b100;
                z <= 0;
            end
            3'b010: begin
                current_state <= (x == 0) ? 3'b010 : 3'b001;
                z <= 0;
            end
            3'b011: begin
                current_state <= (x == 0) ? 3'b001 : 3'b010;
                z <= 1;
            end
            3'b100: begin
                current_state <= (x == 0) ? 3'b011 : 3'b100;
                z <= 1;
            end
            default: begin
                current_state <= 3'b000;
                z <= 0;
            end
        endcase
    end
end

endmodule