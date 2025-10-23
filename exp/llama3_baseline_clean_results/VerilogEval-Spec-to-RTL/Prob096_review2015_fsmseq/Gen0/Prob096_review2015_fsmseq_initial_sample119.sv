module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states
typedef enum logic [1:0] {
    S0,
    S1,
    S2,
    S3,
    S4
} states;

states current_state, next_state;

always @(*) begin
    case(current_state)
        S0: begin
            if(data)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if(data)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if(~data)
                next_state = S3;
            else
                next_state = S1;
        end
        S3: begin
            if(data)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            next_state = S4;
        end
        default: next_state = S0;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        current_state <= S0;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
        if(current_state == S4)
            start_shifting <= 1;
        else if(current_state != S4 && start_shifting == 1)
            start_shifting <= 1; // Keep start_shifting set after sequence found
        else
            start_shifting <= 0;
    end
end

endmodule