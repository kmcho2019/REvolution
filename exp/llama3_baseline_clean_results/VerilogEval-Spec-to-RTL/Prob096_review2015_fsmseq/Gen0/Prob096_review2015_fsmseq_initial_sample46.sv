module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [1:0] state; // Idle = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11, Found = 2'b12 (but we'll use an enum instead for clarity)
reg start_shifting_reg;

// Enum for state
enum logic [1:0] {Idle, S1, S2, S3, Found} curr_state, next_state;

always @(posedge clk) begin
    if (reset) begin
        curr_state <= Idle;
        start_shifting_reg <= 0;
    end else begin
        curr_state <= next_state;
        if (curr_state == Found) start_shifting_reg <= 1;
    end
end

always @(*) begin
    case (curr_state)
        Idle: begin
            if (data) next_state = S1;
            else next_state = Idle;
        end
        S1: begin
            if (data) next_state = S2;
            else next_state = Idle;
        end
        S2: begin
            if (!data) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (data) next_state = Found;
            else next_state = Idle;
        end
        Found: begin
            if (reset) next_state = Idle;
            else next_state = Found;
        end
        default: next_state = Idle; // This should never happen
    endcase
end

assign start_shifting = start_shifting_reg;

endmodule