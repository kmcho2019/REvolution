module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define states
localparam B = 1'b0;
localparam A = 1'b1;

reg state, next_state;

// State transition logic (combinational)
always @(*) begin
    case(state)
        B: begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end
        A: begin
            if (in == 1'b0)
                next_state = B;
            else
                next_state = A;
        end
        default: next_state = B;
    endcase
end

// State update (sequential)
always @(posedge clk) begin
    if (reset)
        state <= B;
    else
        state <= next_state;
end

// Output logic (Moore)
always @(*) begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule