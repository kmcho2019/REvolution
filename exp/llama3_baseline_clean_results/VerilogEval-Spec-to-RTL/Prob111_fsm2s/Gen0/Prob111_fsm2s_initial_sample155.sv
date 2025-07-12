module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
enum logic [0:1] {OFF, ON} state, nextState;

// Output is a function of the state
always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if(j == 1'b1) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if(k == 1'b1) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
        endcase
    end
end

endmodule