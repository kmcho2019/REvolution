module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// Enumerate states
enum {A, B, C} state, next_state;

// Counters
reg [1:0] w_count; // Count w = 1 occurrences
reg [1:0] cycle_count; // Current cycle within 3-cycle window

// State logic
always @(*) begin
    case(state)
        A: begin
            if (reset) begin
                next_state = A;
            end else if (s) begin
                next_state = B;
                w_count = 0;
                cycle_count = 0;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (reset) begin
                next_state = A;
            end else if (cycle_count < 2) begin
                next_state = B;
                if (w) begin
                    w_count = w_count + 1;
                end
                cycle_count = cycle_count + 1;
            end else if (cycle_count == 2) begin
                if (w) begin
                    w_count = w_count + 1;
                end
                next_state = C;
                cycle_count = 0;
            end
        end
        C: begin
            if (reset) begin
                next_state = A;
            end else begin
                next_state = B;
                w_count = 0;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    if (state == C) begin
        z = (w_count == 2);
    end else begin
        z = 0;
    end
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule