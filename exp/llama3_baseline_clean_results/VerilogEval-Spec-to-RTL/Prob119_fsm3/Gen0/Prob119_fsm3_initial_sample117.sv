module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Combinational logic for next state and output
always @(*) begin
    case (current_state)
        A: begin
            if (~in) next_state = A;
            else next_state = B;
            out = 1'b0;
        end
        B: begin
            if (~in) next_state = C;
            else next_state = B;
            out = 1'b0;
        end
        C: begin
            if (~in) next_state = A;
            else next_state = D;
            out = 1'b0;
        end
        D: begin
            if (~in) next_state = C;
            else next_state = B;
            out = 1'b1;
        end
        default: begin
            next_state = A;
            out = 1'b0;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) current_state <= A;
    else current_state <= next_state;
end

endmodule