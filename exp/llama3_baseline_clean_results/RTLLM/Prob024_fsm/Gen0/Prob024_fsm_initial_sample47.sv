module fsm (
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    S5
} state, next_state;

// Output signal
assign MATCH = (state == S5 && IN == 1)? 1'b1 : 1'b0;

// State transition logic
always_comb begin
    case (state)
        IDLE: begin
            if (IN == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (IN == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 1'b0) begin
                next_state = S3;
            end else if (IN == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S2;
            end
        end
        S3: begin
            if (IN == 1'b1) begin
                next_state = S4;
            end else if (IN == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = S3;
            end
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S5;
            end else if (IN == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S4;
            end
        end
        S5: begin
            if (IN == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = S2;
            end
        end
        default: next_state = IDLE;
    endcase
end

// State register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule