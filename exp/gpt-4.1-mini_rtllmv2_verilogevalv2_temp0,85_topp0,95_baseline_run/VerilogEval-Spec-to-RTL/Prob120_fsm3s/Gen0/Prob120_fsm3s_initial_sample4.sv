module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// State encoding
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg [1:0] state, next_state;

// Sequential logic: state update
always @(posedge clk) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Combinational logic: next state and output
always @(*) begin
    case (state)
        A: begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end
        B: begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end
        C: begin
            out = 1'b0;
            if (in == 1'b0)
                next_state = A;
            else
                next_state = D;
        end
        D: begin
            out = 1'b1;
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end
        default: begin
            out = 1'b0;
            next_state = A;
        end
    endcase
end

endmodule