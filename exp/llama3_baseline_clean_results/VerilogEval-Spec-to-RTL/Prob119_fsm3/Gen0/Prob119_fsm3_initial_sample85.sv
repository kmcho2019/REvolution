module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

state_t current_state;
state_t next_state;

always_comb begin
    case (current_state)
        A: next_state = (in == 1'b0)? A : B;
        B: next_state = (in == 1'b0)? C : B;
        C: next_state = (in == 1'b0)? A : D;
        D: next_state = (in == 1'b0)? C : B;
    endcase
end

always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule