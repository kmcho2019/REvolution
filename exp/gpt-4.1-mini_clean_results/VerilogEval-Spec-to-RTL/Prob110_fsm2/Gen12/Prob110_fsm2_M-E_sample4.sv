module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state, next_state;
reg next_out;

// Combinational block to compute next state and next output (Mealy-style internal logic)
always @(*) begin
    case (state)
        OFF: begin
            if (j)
                next_state = ON;
            else
                next_state = OFF;
            next_out = 1'b0; // Moore output depends on state only
        end
        ON: begin
            if (k)
                next_state = OFF;
            else
                next_state = ON;
            next_out = 1'b1; // Moore output depends on state only
        end
        default: begin
            next_state = OFF;
            next_out = 1'b0;
        end
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Output register (Moore output registered)
always @(posedge clk or posedge areset) begin
    if (areset)
        out <= 1'b0;
    else
        out <= next_out;
end

endmodule