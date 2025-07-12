module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define the states
parameter IDLE = 4'd0,
           S1   = 4'd1,
           S2   = 4'd2,
           S3   = 4'd3,
           S4   = 4'd4,
           S5   = 4'd5;

reg [3:0] state, next_state;

// Initialize the state to IDLE
initial state = IDLE;

// Sequential logic for state transition
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always @(*) begin
    case (state)
        IDLE: begin
            if (IN) begin
                next_state = S1;
                MATCH = 1'b0;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        S1: begin
            if (~IN) begin
                next_state = S2;
                MATCH = 1'b0;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        S2: begin
            if (~IN) begin
                next_state = S3;
                MATCH = 1'b0;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
                MATCH = 1'b0;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
                MATCH = 1'b1;
            end else begin
                next_state = IDLE;
                MATCH = 1'b0;
            end
        end
        S5: begin
            if (~IN) begin
                next_state = IDLE;
                MATCH = 1'b0;
            end else begin
                next_state = S5;
                MATCH = 1'b1;
            end
        end
        default: begin
            next_state = IDLE;
            MATCH = 1'b0;
        end
    endcase
end

endmodule