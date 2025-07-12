module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

// Sequential logic to handle state transitions and reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
            C: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= D;
                end
            end
            D: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
            default: state <= A; // Default to state A if needed
        endcase
    end
end

// Combinational logic to determine output based on state
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output to 0 if needed
    endcase
end

endmodule