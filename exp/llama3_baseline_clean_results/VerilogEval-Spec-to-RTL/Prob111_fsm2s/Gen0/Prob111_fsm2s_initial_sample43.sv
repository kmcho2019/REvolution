module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define states as enumeration
enum {OFF, ON} state, next_state;

// Assign output based on state
always @(state) begin
    case(state)
        OFF: out = 0;
        ON: out = 1;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if(k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
        endcase
    end
end

endmodule