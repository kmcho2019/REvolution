module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state; // Current state of the FSM
reg [2:0] next_state; // Next state of the FSM

// Define the states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

// FSM state transitions
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                end else begin
                    state <= S0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                end else begin
                    state <= S0;
                end
            end
            S5: begin
                state <= S0;
            end
            default: begin
                state <= S0;
            end
        endcase
    end
end

// Output logic
always @(state) begin
    case (state)
        S5: begin
            MATCH = 1'b1;
        end
        default: begin
            MATCH = 1'b0;
        end
    endcase
end

endmodule