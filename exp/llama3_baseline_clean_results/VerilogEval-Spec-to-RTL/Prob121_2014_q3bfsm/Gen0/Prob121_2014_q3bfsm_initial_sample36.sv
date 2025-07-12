module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;
reg       outputZ;

always @(posedge clk) begin
    if(reset) begin
        currentState <= 3'b000;
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    case(currentState)
        3'b000: begin
            if(!x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
            outputZ = 1'b0;
        end
        3'b001: begin
            if(!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
            outputZ = 1'b0;
        end
        3'b010: begin
            if(!x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
            outputZ = 1'b0;
        end
        3'b011: begin
            if(!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
            outputZ = 1'b1;
        end
        3'b100: begin
            if(!x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
            outputZ = 1'b1;
        end
        default: begin
            nextState = 3'b000;
            outputZ = 1'b0;
        end
    endcase
end

assign z = outputZ;

endmodule