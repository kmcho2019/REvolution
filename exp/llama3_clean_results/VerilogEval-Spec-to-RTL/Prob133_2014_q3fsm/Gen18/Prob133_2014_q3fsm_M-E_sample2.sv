module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

typedef enum logic [1:0] {A, B_ENTER, B_WAIT1, B_WAIT2, B_EVAL} state_t;
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
                if(w_count == 2'b10) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                state <= B_ENTER;
                w_count <= 2'b00;
            end
            default: ;
        endcase
    end
end

endmodule