module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for states
enum logic [2:0] {S0, S1, S2, S3, S4} state, next_state;

always_comb begin
    case(state)
        S0: begin
            if(data) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if(data) begin
                next_state = S2;
            end else begin
                next_state = S0;
            end
        end
        S2: begin
            if(~data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if(data) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            next_state = S4;
        end
        default: next_state = S0;
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(state == S4) begin
            start_shifting <= 1;
        end else if (next_state != S4) begin
            start_shifting <= 0;
        end
    end
end

endmodule