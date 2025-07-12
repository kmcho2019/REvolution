module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] nextState;

always @(y, x) begin
    case (y)
        3'b000: 
            if (!x) 
                nextState = 3'b000; 
            else 
                nextState = 3'b001;
        3'b001: 
            if (!x) 
                nextState = 3'b001; 
            else 
                nextState = 3'b100;
        3'b010: 
            if (!x) 
                nextState = 3'b010; 
            else 
                nextState = 3'b001;
        3'b011: 
            if (!x) 
                nextState = 3'b001; 
            else 
                nextState = 3'b010;
        3'b100: 
            if (!x) 
                nextState = 3'b011; 
            else 
                nextState = 3'b100;
        default: 
            nextState = 3'bxxx; // default or unknown state handling
    endcase
end

always @(y, x) begin
    case (y)
        3'b000, 3'b001, 3'b010: 
            z = 1'b0;
        3'b011: 
            z = 1'b1;
        3'b100: 
            z = 1'b1;
        default: 
            z = 1'b0; // default or unknown state handling
    endcase
end

assign Y0 = (x == 1'b0) ? y[0] : nextState[0];

always @(posedge clk) begin
    y <= nextState;
end

endmodule