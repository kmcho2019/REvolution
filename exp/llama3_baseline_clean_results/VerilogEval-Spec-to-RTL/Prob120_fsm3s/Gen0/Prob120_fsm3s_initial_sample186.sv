module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states as enum
enum logic [1:0] {A, B, C, D} state, next_state;

// Define output based on state
always_comb begin
    case(state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Define state transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        case(state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A;
        endcase
    end
end

endmodule