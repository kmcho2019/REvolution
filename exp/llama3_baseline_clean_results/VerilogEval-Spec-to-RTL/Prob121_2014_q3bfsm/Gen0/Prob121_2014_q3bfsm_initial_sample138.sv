module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y;
reg [2:0] next_y;
reg z_next;

always @(*)
begin
    case(y)
        3'b000: begin
            next_y = (x == 1'b0) ? 3'b000 : 3'b001;
            z_next = 1'b0;
        end
        3'b001: begin
            next_y = (x == 1'b0) ? 3'b001 : 3'b100;
            z_next = 1'b0;
        end
        3'b010: begin
            next_y = (x == 1'b0) ? 3'b010 : 3'b001;
            z_next = 1'b0;
        end
        3'b011: begin
            next_y = (x == 1'b0) ? 3'b001 : 3'b010;
            z_next = 1'b1;
        end
        3'b100: begin
            next_y = (x == 1'b0) ? 3'b011 : 3'b100;
            z_next = 1'b1;
        end
        default: begin
            next_y = 3'b000;
            z_next = 1'b0;
        end
    endcase
end

always @(posedge clk)
begin
    if(reset)
        y <= 3'b000;
    else
        y <= next_y;
end

assign z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;

endmodule