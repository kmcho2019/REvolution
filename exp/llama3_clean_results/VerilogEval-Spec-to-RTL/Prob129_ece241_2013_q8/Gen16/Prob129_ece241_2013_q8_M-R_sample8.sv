module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

typedef enum logic [1:0] {
    S00,
    S01,
    S10
} state_t;

state_t state, next_state;
reg [1:0] shift_reg;

// State register
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S00;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        S00: begin
            if (x) begin
                next_state = S01;
            end else begin
                next_state = S00;
            end
        end
        S01: begin
            if (!x) begin
                next_state = S10;
            end else begin
                next_state = S01;
            end
        end
        S10: begin
            if (x) begin
                next_state = S01;
            end else begin
                next_state = S00;
            end
        end
        default: next_state = S00;
    endcase
end

// Output logic
assign z = (state == S10) && x;

endmodule