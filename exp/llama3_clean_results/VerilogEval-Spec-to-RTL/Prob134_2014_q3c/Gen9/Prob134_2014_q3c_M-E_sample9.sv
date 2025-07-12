module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState;
wire [2:0] nextState;
wire z_int;

assign Y0 = nextState[0];

always @(posedge clk) begin
    currentState <= nextState;
end

always @(*) begin
    case (y)
        3'b000: begin
            nextState = x ? 3'b001 : 3'b000;
            z_int = 1'b0;
        end
        3'b001: begin
            nextState = x ? 3'b100 : 3'b001;
            z_int = 1'b0;
        end
        3'b010: begin
            nextState = x ? 3'b001 : 3'b010;
            z_int = 1'b0;
        end
        3'b011: begin
            nextState = x ? 3'b010 : 3'b001;
            z_int = 1'b1;
        end
        3'b100: begin
            nextState = x ? 3'b100 : 3'b011;
            z_int = 1'b1;
        end
        default: begin
            nextState = 3'b000;
            z_int = 1'b0;
        end
    endcase
end

assign z = z_int;

initial begin
    currentState = 3'b000;
end

endmodule