module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;
reg Y0_reg;
reg z_reg;

always @(*) begin
    case (y) // Use 'y' for the case statement since 'currentState' is assigned 'y'
        3'b000: begin
            if (!x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
            z_reg = 1'b0;
        end
        3'b001: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
            z_reg = 1'b0;
        end
        3'b010: begin
            if (!x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
            z_reg = 1'b0;
        end
        3'b011: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
            z_reg = 1'b1;
        end
        3'b100: begin
            if (!x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
            z_reg = 1'b1;
        end
        default: begin // For all other states, default to an initial state
            nextState = 3'b000;
            z_reg = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    currentState <= y; // Direct assignment, assuming 'y' is the current state input
    Y0_reg <= nextState[0]; // Y0 is the least significant bit of the next state
    z <= z_reg;
end

assign Y0 = Y0_reg;

endmodule