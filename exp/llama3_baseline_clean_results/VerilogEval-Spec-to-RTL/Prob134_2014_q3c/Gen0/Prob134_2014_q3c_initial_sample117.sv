module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState; // Register to hold the current state
reg [2:0] nextState; // Variable to calculate the next state
reg z_out; // Variable for output z

// Initialize the current state at the start
initial begin
    currentState = 3'b000;
end

// At every positive edge of the clock, update the current state
always @(posedge clk) begin
    currentState <= nextState;
end

// Combinational logic to determine the next state and output z
always @(*) begin
    case (currentState)
        3'b000: begin
            if (!x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
            z_out = 1'b0;
        end
        3'b001: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
            z_out = 1'b0;
        end
        3'b010: begin
            if (!x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
            z_out = 1'b0;
        end
        3'b011: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
            z_out = 1'b1;
        end
        3'b100: begin
            if (!x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
            z_out = 1'b1;
        end
        default: begin // For any other state, reset to 000
            nextState = 3'b000;
            z_out = 1'b0;
        end
    endcase
    Y0 = nextState[0]; // Y0 is the least significant bit of the next state
    z = z_out;
end

endmodule