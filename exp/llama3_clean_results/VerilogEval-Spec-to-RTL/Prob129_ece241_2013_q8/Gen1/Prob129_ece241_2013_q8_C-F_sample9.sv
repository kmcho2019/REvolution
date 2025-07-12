module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states using enum
enum logic [1:0] {
    S0 = 2'b00, // Idle
    S1 = 2'b01, // Got1
    S2 = 2'b10  // Got10
} state, next_state;

// State register
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (!x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1; // recognized "101"
            end else begin
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Output logic
assign z = (state == S2 && x); // z asserted in S2 when x is '1'

endmodule