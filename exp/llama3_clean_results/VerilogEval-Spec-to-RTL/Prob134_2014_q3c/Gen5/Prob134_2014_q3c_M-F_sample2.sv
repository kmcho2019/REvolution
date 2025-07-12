module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

// Define states using enum
typedef enum logic [2:0] {
    S000,
    S001,
    S010,
    S011,
    S100
} state_type;

reg state_type state, nextState;

// Combinational logic to determine next state and output z
always @(*) begin
    case (state)
        S000: begin
            if (!x) begin
                nextState = S000;
            end else begin
                nextState = S001;
            end
            z = 1'b0;
        end
        S001: begin
            if (!x) begin
                nextState = S001;
            end else begin
                nextState = S100;
            end
            z = 1'b0;
        end
        S010: begin
            if (!x) begin
                nextState = S010;
            end else begin
                nextState = S001;
            end
            z = 1'b0;
        end
        S011: begin
            if (!x) begin
                nextState = S001;
            end else begin
                nextState = S010;
            end
            z = 1'b1;
        end
        S100: begin
            if (!x) begin
                nextState = S011;
            end else begin
                nextState = S100;
            end
            z = 1'b1;
        end
    endcase
end

// Sequential logic to update current state
always @(posedge clk) begin
    state <= nextState;
end

// Continuous assignment to assign Y0
assign Y0 = nextState[0];

// Initialize state and nextState
initial begin
    state = S000;
    nextState = S000;
end

endmodule