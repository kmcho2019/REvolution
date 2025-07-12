module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y;
reg [2:0] next_state;
reg z_next;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= next_state;
    end
end

always @(*) begin
    case (y)
        3'b000: begin
            if (!x) next_state = 3'b000;
            else next_state = 3'b001;
            z_next = 1'b0;
        end
        3'b001: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b100;
            z_next = 1'b0;
        end
        3'b010: begin
            if (!x) next_state = 3'b010;
            else next_state = 3'b001;
            z_next = 1'b0;
        end
        3'b011: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b010;
            z_next = 1'b1;
        end
        3'b100: begin
            if (!x) next_state = 3'b011;
            else next_state = 3'b100;
            z_next = 1'b1;
        end
        default: begin
            next_state = 3'b000;
            z_next = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    z <= z_next;
end

endmodule