module fsm(
    input       IN,
    input       CLK,
    input       RST,
    output reg  MATCH
);

// Define states
enum logic [2:0] {S0, S1, S2, S3, S4, S5} state, next_state;

// Always block for sequential logic (state register)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        state <= next_state;
        if (state == S5) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

// Combinational logic for next state and output
always @(*) begin
    case(state)
        S0: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (IN == 1 || IN == 0) begin
                next_state = S0;
            end else begin
                next_state = S5;
            end
        end
        default: next_state = S0;
    endcase
end

endmodule