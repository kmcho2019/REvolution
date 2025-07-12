module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;

// Sequential logic
always @ (posedge clk) begin
    case (y)
        3'b000: current_state <= x? 3'b001 : 3'b000;
        3'b001: current_state <= x? 3'b100 : 3'b001;
        3'b010: current_state <= x? 3'b001 : 3'b010;
        3'b011: current_state <= x? 3'b010 : 3'b001;
        3'b100: current_state <= x? 3'b100 : 3'b011;
    endcase
end

// Combinational logic for output z and Y0
always @ (*) begin
    z = (y == 3'b011 || y == 3'b100);
    Y0 = (x == 1'b0)? y[0] : 
         (y == 3'b000)? 1'b0 : 
         (y == 3'b001)? 1'b1 : 
         (y == 3'b010)? 1'b0 : 
         (y == 3'b011)? 1'b0 : 
         (y == 3'b100)? 1'b0;
end

endmodule