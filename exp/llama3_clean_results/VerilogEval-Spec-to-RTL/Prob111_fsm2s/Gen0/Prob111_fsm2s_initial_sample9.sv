module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enum to represent the states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic for each state
always_comb begin
    case(state)
        OFF: out = 0;
        ON:  out = 1;
        default: out = 0;
    endcase
end

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: if(j) state <= ON; else state <= OFF;
            ON:  if(k) state <= OFF; else state <= ON;
            default: state <= OFF;
        endcase
    end
end

endmodule