module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define the states
enum logic [1:0] {OFF, ON} current_state, next_state;

// Output logic
always_comb begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'bx;
    endcase
end

// State logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: begin
                if (j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            default: current_state <= OFF;
        endcase
    end
end

endmodule