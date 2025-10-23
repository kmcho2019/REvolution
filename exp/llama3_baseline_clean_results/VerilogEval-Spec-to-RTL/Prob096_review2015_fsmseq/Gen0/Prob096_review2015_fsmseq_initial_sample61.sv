module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Enum for states
enum logic [2:0] {
    Idle = 3'b000,
    Seq1  = 3'b001,
    Seq11 = 3'b010,
    Seq110 = 3'b011,
    Seq1101 = 3'b100
} state, next_state;

// Current state register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == Seq1101) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

// Next state logic
always_comb begin
    case (state)
        Idle: begin
            if (data) begin
                next_state = Seq1;
            end else begin
                next_state = Idle;
            end
        end
        Seq1: begin
            if (data) begin
                next_state = Seq11;
            end else begin
                next_state = Seq1;
            end
        end
        Seq11: begin
            if (data) begin
                next_state = Seq110;
            end else begin
                next_state = Seq1;
            end
        end
        Seq110: begin
            if (data) begin
                next_state = Seq110;
            end else begin
                next_state = Seq1101;
            end
        end
        Seq1101: begin
            next_state = Seq1101;
        end
        default: next_state = Idle;
    endcase
end

endmodule