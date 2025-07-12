module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Enum for states
enum logic [0:0] {OFF, ON} state, next_state;

// State register
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case(state)
        OFF: begin
            if(j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
            out = 0;
        end
        ON: begin
            if(k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
            out = 1;
        end
        default: begin
            next_state = OFF;
            out = 0;
        end
    endcase
end

endmodule