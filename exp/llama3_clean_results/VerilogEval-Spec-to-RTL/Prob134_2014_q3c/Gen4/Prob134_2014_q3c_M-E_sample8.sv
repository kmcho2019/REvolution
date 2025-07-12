module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] state, nextState;

// Combinational logic to determine next state and output z
always @(*) begin
    case (y)
        3'b000: begin
            if (!x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
            z = 1'b0;
        end
        3'b001: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
            z = 1'b0;
        end
        3'b010: begin
            if (!x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
            z = 1'b0;
        end
        3'b011: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
            z = 1'b1;
        end
        3'b100: begin
            if (!x) begin
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

// Sequential logic to update current state
always @(posedge clk) begin
    state <= nextState;
end

// Continuous assignment to assign Y0
assign Y0 = nextState[0];

// Initialize state
initial begin
    state = 3'b000;
end

endmodule