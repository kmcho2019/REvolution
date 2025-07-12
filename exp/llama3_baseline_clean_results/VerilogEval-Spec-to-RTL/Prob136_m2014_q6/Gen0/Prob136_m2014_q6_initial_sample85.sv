module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
typedef enum logic [3:0] {
    A = 4'd0,
    B = 4'd1,
    C = 4'd2,
    D = 4'd3,
    E = 4'd4,
    F = 4'd5
} state_type;

// Current state and next state
state_type current_state, next_state;

// Output z
assign z = (current_state == E || current_state == F);

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        A: begin
            if (~w) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (~w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        C: begin
            if (~w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (~w) begin
                next_state = F;
            end else begin
                next_state = A;
            end
        end
        E: begin
            if (~w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        F: begin
            if (~w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        default: next_state = A;
    endcase
end

endmodule