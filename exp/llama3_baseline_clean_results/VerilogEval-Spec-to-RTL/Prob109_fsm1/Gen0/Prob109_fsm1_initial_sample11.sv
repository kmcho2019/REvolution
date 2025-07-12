module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
enum logic [1:0] {A, B} state, next_state;

// Assign output based on state
always_comb begin
    case(state)
        A: out = 0;
        B: out = 1;
        default: out = 1'b0; // Default output
    endcase
end

// State machine logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= B;
    end else begin
        case(state)
            A: begin
                if(in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if(in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            default: state <= B; // Default next state
        endcase
    end
end

endmodule