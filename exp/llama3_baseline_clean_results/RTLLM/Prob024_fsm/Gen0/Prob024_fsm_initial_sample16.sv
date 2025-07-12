module fsm(
    input  logic IN, CLK, RST,
    output logic MATCH
);

// Define the states
parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5;

// Declare the current state and next state
logic [3:0] current_state, next_state;

// Assign the output based on the current state
always_comb begin
    case(current_state)
        S5: MATCH = (IN == 1) ? 1'b1 : 1'b0;
        default: MATCH = 1'b0;
    endcase
end

// Handle the state transitions
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
    end else begin
        case(current_state)
            S0: begin
                if (IN == 1) current_state <= S1;
                else current_state <= S0;
            end
            S1: begin
                if (IN == 0) current_state <= S2;
                else current_state <= S1;
            end
            S2: begin
                if (IN == 0) current_state <= S3;
                else current_state <= S1;
            end
            S3: begin
                if (IN == 1) current_state <= S4;
                else current_state <= S0;
            end
            S4: begin
                if (IN == 1) current_state <= S5;
                else current_state <= S0;
            end
            S5: begin
                if (IN == 1) current_state <= S5;
                else current_state <= S0;
            end
            default: current_state <= S0;
        endcase
    end
end

endmodule