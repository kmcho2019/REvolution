module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState, nextState;
reg Y0_next, z_next;

always @(posedge clk) begin
    currentState <= nextState;
    Y0 <= Y0_next;
    z <= z_next;
end

always @(*) begin
    case (currentState)
        3'b000: begin
            if (!x) begin
                nextState = 3'b000;
                z_next = 1'b0;
            end else begin
                nextState = 3'b001;
                z_next = 1'b0;
            end
        end
        3'b001: begin
            if (!x) begin
                nextState = 3'b001;
                z_next = 1'b0;
            end else begin
                nextState = 3'b100;
                z_next = 1'b0;
            end
        end
        3'b010: begin
            if (!x) begin
                nextState = 3'b010;
                z_next = 1'b0;
            end else begin
                nextState = 3'b001;
                z_next = 1'b0;
            end
        end
        3'b011: begin
            if (!x) begin
                nextState = 3'b001;
                z_next = 1'b1;
            end else begin
                nextState = 3'b010;
                z_next = 1'b1;
            end
        end
        3'b100: begin
            if (!x) begin
                nextState = 3'b011;
                z_next = 1'b1;
            end else begin
                nextState = 3'b100;
                z_next = 1'b1;
            end
        end
        default: begin
            nextState = 3'b000;
            z_next = 1'b0;
        end
    endcase
    Y0_next = nextState[0];
end

endmodule