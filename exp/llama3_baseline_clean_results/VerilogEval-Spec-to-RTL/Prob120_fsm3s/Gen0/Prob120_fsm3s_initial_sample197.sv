module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define states as enumeration
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current state register
state_t current_state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (~in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            B: begin
                if (~in) begin
                    current_state <= C;
                end else begin
                    current_state <= B;
                end
            end
            C: begin
                if (~in) begin
                    current_state <= A;
                end else begin
                    current_state <= D;
                end
            end
            D: begin
                if (~in) begin
                    current_state <= C;
                end else begin
                    current_state <= B;
                end
            end
        endcase
    end
end

// Output logic (Moore machine output depends solely on the current state)
always @(current_state) begin
    case (current_state)
        A, B, C: out <= 1'b0;
        D: out <= 1'b1;
    endcase
end

endmodule