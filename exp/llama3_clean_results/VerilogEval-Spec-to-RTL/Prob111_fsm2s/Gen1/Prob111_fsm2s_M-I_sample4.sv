module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the states
enum {OFF, ON} state, next_state;

// Output logic
always_comb begin
    out = (state == ON) ? 1'b1 : 1'b0;
end

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
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