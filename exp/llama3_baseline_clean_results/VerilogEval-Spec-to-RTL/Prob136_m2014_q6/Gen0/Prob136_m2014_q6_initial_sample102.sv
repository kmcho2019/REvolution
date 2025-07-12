module TopModule(
    input           clk,
    input           reset,
    input           w,
    output reg      z
);

// Define the states as an enum
enum logic [2:0] {
    A, B, C, D, E, F
} state, next_state;

// Initial state
initial state = A;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @* begin
    case (state)
        A: begin
            if (w) begin
                next_state = A;
                z = 0;
            end else begin
                next_state = B;
                z = 0;
            end
        end
        B: begin
            if (w) begin
                next_state = D;
                z = 0;
            end else begin
                next_state = C;
                z = 0;
            end
        end
        C: begin
            if (w) begin
                next_state = D;
                z = 0;
            end else begin
                next_state = E;
                z = 0;
            end
        end
        D: begin
            if (w) begin
                next_state = A;
                z = 0;
            end else begin
                next_state = F;
                z = 0;
            end
        end
        E: begin
            if (w) begin
                next_state = D;
                z = 1;
            end else begin
                next_state = E;
                z = 1;
            end
        end
        F: begin
            if (w) begin
                next_state = D;
                z = 1;
            end else begin
                next_state = C;
                z = 1;
            end
        end
    endcase
end

endmodule