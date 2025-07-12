module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg [1:0] current_state;
reg [1:0] next_state;

// State transition logic
always @(*) begin
    case(current_state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
        end
        default: next_state = A;
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) current_state <= A;
    else current_state <= next_state;
end

// Output logic
always @(*) begin
    case(current_state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule