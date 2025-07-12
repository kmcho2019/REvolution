module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

typedef enum logic [2:0] {
    A = 3'b000,
    B_ENTER = 3'b001,
    B_WAIT1 = 3'b010,
    B_WAIT2 = 3'b011,
    B_EVAL = 3'b100
} state_t;
state_t state;

reg [1:0] w_count;

always @(posedge clk) begin
    if(reset) begin
        state <= A;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B_ENTER;
                    w_count <= 2'b00;
                end
            end
            B_ENTER: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                state <= B_WAIT1;
            end
            B_WAIT1: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                state <= B_WAIT2;
            end
            B_WAIT2: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                state <= B_EVAL;
            end
            B_EVAL: begin
                z <= (w_count == 2'b10)? 1'b1 : 1'b0;
                state <= B_ENTER;
                w_count <= 2'b00;
            end
            default: state <= A; // Handle unintended states by resetting to A
        endcase
    end
end

endmodule