module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Enumerate the states
enum logic [2:0] {
    Idle = 3'b000,
    Found_1 = 3'b001,
    Found_11 = 3'b010,
    Found_110 = 3'b011,
    Found_1101 = 3'b100
} state, next_state;

// Initialize the output signal
assign start_shifting = (state == Found_1101) ? 1'b1 : 1'b0;

// Define the state machine
always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

// Define the next state logic
always @(*) begin
    case (state)
        Idle: begin
            if (data == 1'b1) begin
                next_state <= Found_1;
            end else begin
                next_state <= Idle;
            end
        end
        Found_1: begin
            if (data == 1'b1) begin
                next_state <= Found_11;
            end else if (data == 1'b0) begin
                next_state <= Found_1101;
            end else begin
                next_state <= Found_1;
            end
        end
        Found_11: begin
            if (data == 1'b0) begin
                next_state <= Found_110;
            end else begin
                next_state <= Found_1;
            end
        end
        Found_110: begin
            if (data == 1'b1) begin
                next_state <= Found_1101;
            end else begin
                next_state <= Idle;
            end
        end
        Found_1101: begin
            next_state <= Found_1101;
        end
    endcase
end

endmodule