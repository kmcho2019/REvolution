module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    S5
} state, next_state;

// Sequential logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
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

// Combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            if (IN) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE;
            end
        end
        S1: begin
            if (~IN) begin
                next_state <= S2;
            end else begin
                next_state <= S1;
            end
        end
        S2: begin
            if (~IN) begin
                next_state <= S3;
            end else begin
                next_state <= IDLE;
            end
        end
        S3: begin
            if (IN) begin
                next_state <= S4;
            end else begin
                next_state <= IDLE;
            end
        end
        S4: begin
            if (IN) begin
                next_state <= S5;
            end else begin
                next_state <= IDLE;
            end
        end
        S5: begin
            if (IN) begin
                next_state <= S5;
            end else begin
                next_state <= IDLE;
            end
        end
    endcase
end

endmodule