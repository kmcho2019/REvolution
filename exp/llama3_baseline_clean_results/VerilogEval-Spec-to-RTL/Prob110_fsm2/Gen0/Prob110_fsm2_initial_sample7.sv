module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
assign out = state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case(state)
        OFF: begin
            if(j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if(k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

endmodule