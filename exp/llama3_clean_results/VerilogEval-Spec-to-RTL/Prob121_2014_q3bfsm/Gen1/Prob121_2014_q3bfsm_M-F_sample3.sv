module TopModule (
    input clk,
    input reset,
    input x,
    output reg z // Declare z as a reg instead of a wire
);

reg [2:0] state;
reg [2:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        3'b000: begin
            if (~x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
            z = 1'b0;
        end
        3'b001: begin
            if (~x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
            z = 1'b0;
        end
        3'b010: begin
            if (~x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
            z = 1'b0;
        end
        3'b011: begin
            if (~x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
            z = 1'b1;
        end
        3'b100: begin
            if (~x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
            z = 1'b1;
        end
        default: begin
            nextState = 3'b000;
            z = 1'b0;
        end
    endcase
end

endmodule