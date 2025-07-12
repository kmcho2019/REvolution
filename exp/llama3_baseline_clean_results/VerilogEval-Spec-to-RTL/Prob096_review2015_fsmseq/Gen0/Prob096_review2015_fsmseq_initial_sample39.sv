module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Define states
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// Current state logic
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == S4) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        S0: begin
            if (data) begin
                next_state = S1;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = S0;
            end
        end
        S2: begin
            if (!data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            next_state = S4;
        end
    endcase
end

endmodule