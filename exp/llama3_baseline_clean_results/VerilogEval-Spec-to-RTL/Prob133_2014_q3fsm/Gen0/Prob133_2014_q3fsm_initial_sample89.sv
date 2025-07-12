module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// Define states
enum {A, B, B1, B2, B3} state, next_state;

// Counter for 'w'
reg [1:0] w_count;

// Output 'z'
reg z_reg;

always @(*) begin
    next_state = state;
    case (state)
        A: begin
            if (s) next_state = B;
        end
        B: begin
            next_state = B1;
            if (w) w_count = 1;
            else w_count = 0;
        end
        B1: begin
            next_state = B2;
            if (w) w_count = w_count + 1;
        end
        B2: begin
            next_state = B3;
            if (w) w_count = w_count + 1;
        end
        B3: begin
            next_state = B;
            if (w) w_count = w_count + 1;
            if (w_count == 2) z_reg = 1;
            else z_reg = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        w_count <= 0;
        z_reg <= 0;
    end else begin
        state <= next_state;
    end
end

assign z = (state == B3) ? z_reg : 0;

endmodule