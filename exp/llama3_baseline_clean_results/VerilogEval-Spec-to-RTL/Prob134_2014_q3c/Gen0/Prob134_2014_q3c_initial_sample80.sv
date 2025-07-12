module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState;

always @(*) begin
    case (y)
        3'b000: 
            if (!x) begin
                currentState = 3'b000;
                z = 0;
            end else begin
                currentState = 3'b001;
                z = 0;
            end
        3'b001: 
            if (!x) begin
                currentState = 3'b001;
                z = 0;
            end else begin
                currentState = 3'b100;
                z = 0;
            end
        3'b010: 
            if (!x) begin
                currentState = 3'b010;
                z = 0;
            end else begin
                currentState = 3'b001;
                z = 0;
            end
        3'b011: 
            if (!x) begin
                currentState = 3'b001;
                z = 1;
            end else begin
                currentState = 3'b010;
                z = 1;
            end
        3'b100: 
            if (!x) begin
                currentState = 3'b011;
                z = 1;
            end else begin
                currentState = 3'b100;
                z = 1;
            end
        default: begin
            currentState = 3'b000;
            z = 0;
        end
    endcase
    Y0 = currentState[0];
end

always @(posedge clk) begin
    y <= currentState;
end

endmodule