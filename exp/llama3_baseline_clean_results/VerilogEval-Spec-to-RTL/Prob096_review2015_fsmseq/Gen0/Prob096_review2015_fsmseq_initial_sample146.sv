module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for the finite-state machine
enum logic [2:0] {
    Idle = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    Found = 3'b100
} state, next_state;

// Define the initial state
initial state = Idle;

// Sequential logic to update state
always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == Found) begin
            start_shifting <= 1;
        end
    end
end

// Combinational logic to determine next state
always @(*) begin
    case (state)
        Idle: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = Idle;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = Idle;
            end
        end
        S2: begin
            if (~data) begin
                next_state = S3;
            end else begin
                next_state = S2;
            end
        end
        S3: begin
            if (data) begin
                next_state = Found;
            end else begin
                next_state = S1;
            end
        end
        Found: begin
            next_state = Found;
        end
        default: begin
            next_state = Idle;
        end
    endcase
end

endmodule