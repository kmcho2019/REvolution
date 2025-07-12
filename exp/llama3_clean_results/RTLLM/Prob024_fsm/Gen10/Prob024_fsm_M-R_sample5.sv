module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define states
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
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
                next_state = S0;
            end else begin
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Combinational logic for output
assign MATCH = (state == S4 && IN);

endmodule