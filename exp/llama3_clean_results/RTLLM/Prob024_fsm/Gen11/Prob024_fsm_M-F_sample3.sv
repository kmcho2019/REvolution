module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define states
enum logic [3:0] {
    S0 = 4'b0000,
    S1 = 4'b0001,
    S2 = 4'b0010,
    S3 = 4'b0011,
    S4 = 4'b0100,
    S5 = 4'b0101
} state, next_state;

// Sequential logic for state register
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always_comb begin
    case (state)
        S0: begin
            if (IN) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (!IN) begin
                next_state = S2;
            end else begin
                next_state = S0;
            end
        end
        S2: begin
            if (!IN) begin
                next_state = S3;
            end else begin
                next_state = S0;
            end
        end
        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            next_state = S0;
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Combinational logic for output
assign MATCH = (state == S5);

endmodule