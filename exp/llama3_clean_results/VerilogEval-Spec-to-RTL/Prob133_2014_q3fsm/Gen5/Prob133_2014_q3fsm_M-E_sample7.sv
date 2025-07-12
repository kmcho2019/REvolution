module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
enum {A, B} state, next_state;

// Pipeline stages
reg w_prev1;
reg w_prev2;

// Next state and output logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
        w_prev1 <= 1'b0;
        w_prev2 <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                end else begin
                    state <= A;
                end
                w_prev1 <= 1'b0;
                w_prev2 <= 1'b0;
            end
            B: begin
                state <= B;
                w_prev2 <= w_prev1;
                w_prev1 <= w;
                if(w_prev2 + w_prev1 + w == 2) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
            end
        endcase
    end
end

endmodule