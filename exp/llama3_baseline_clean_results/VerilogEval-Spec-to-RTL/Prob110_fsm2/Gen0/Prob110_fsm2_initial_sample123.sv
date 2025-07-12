module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output logic out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

// State transition logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if(j) state <= ON;
                else state <= OFF;
            end
            ON: begin
                if(k) state <= OFF;
                else state <= ON;
            end
        endcase
    end
end

endmodule