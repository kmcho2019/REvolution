module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01
} state_type;

state_type current_state;
state_type next_state;

always_comb begin
    case (current_state)
        A: begin
            if (in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B;
    endcase
end

always @(posedge clk or negedge areset) begin
    if (~areset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

assign out = (current_state == A) ? 0 : 1;

endmodule