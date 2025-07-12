module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Enumerate the states
enum {OFF, ON} state, next_state;

// Asynchronous reset to state OFF
always @(posedge clk or posedge areset)
begin
    if(areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always @*
begin
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

    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule