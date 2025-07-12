module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Enum for states
enum logic [0:0] {B, A} current_state, next_state;

// Assign output based on current state
always_comb begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

// State transition logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        case(current_state)
            B: begin
                if (~in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            A: begin
                if (~in) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: current_state <= B;
        endcase
    end
end

endmodule