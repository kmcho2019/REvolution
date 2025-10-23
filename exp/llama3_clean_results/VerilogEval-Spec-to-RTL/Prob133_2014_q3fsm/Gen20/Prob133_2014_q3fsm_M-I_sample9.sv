module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    EVAL = 2'b10
} state_t;
state_t state;

reg [1:0] w_count;
reg [1:0] cycle_count;

always @(posedge clk) begin
    if(reset) begin
        state <= A;
        w_count <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                    w_count <= 2'b00;
                    cycle_count <= 2'b00;
                end
            end
            B: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                cycle_count <= cycle_count + 1'b1;
                if(cycle_count == 2'b11) begin // After 3 cycles
                    state <= EVAL;
                end
            end
            EVAL: begin
                z <= (w_count == 2'b10)? 1'b1 : 1'b0; // Set z based on w_count
                state <= B; // Transition back to B for continuous checking
                w_count <= 2'b00;
                cycle_count <= 2'b00;
            end
            default: state <= A; // Handle unintended states by resetting to A
        endcase
    end
end

endmodule