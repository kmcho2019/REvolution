module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] current_state; // using 2 bits to represent the 2 states A and B
reg [1:0] next_state;

parameter STATE_B = 1'b1; // Define states as parameters
parameter STATE_A = 1'b0;

// Output logic
always @(current_state) begin
    case(current_state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
        default: out = 1'b0; // default to 0 if state is unknown
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_B;
    end else begin
        case(current_state)
            STATE_B: begin
                if (in == 1'b1) begin
                    current_state <= STATE_B;
                end else begin
                    current_state <= STATE_A;
                end
            end
            STATE_A: begin
                if (in == 1'b1) begin
                    current_state <= STATE_A;
                end else begin
                    current_state <= STATE_B;
                end
            end
            default: current_state <= STATE_B; // default to state B if state is unknown
        endcase
    end
end

endmodule