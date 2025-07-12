module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] state;
assign Y0 = state[0];

always @(posedge clk) begin
    case (y)
        3'b000: begin
            state <= x? 3'b001 : 3'b000;
            z <= 1'b0;
        end
        3'b001: begin
            state <= x? 3'b100 : 3'b001;
            z <= 1'b0;
        end
        3'b010: begin
            state <= x? 3'b001 : 3'b010;
            z <= 1'b0;
        end
        3'b011: begin
            state <= x? 3'b010 : 3'b001;
            z <= 1'b1;
        end
        3'b100: begin
            state <= x? 3'b100 : 3'b011;
            z <= 1'b1;
        end
    endcase
end

initial begin
    state = 3'b000; // initialize state
    z = 1'b0; // initialize output z
end

endmodule