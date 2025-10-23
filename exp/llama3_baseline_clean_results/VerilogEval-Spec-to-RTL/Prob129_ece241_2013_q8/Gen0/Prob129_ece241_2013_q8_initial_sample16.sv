module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {IDLE, S1, S2} state, next_state;

// Asynchronous reset
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// State logic
always_comb begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
assign z = (state == S2) && x;

endmodule