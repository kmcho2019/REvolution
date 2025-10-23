module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case (current_state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case (current_state)
        A: begin
            if (~in) next_state = A;
            else next_state = B;
        end
        B: begin
            if (~in) next_state = C;
            else next_state = B;
        end
        C: begin
            if (~in) next_state = A;
            else next_state = D;
        end
        D: begin
            if (~in) next_state = C;
            else next_state = B;
        end
        default: next_state = A;
    endcase
end

// State transition logic with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end
    else begin
        current_state <= next_state;
    end
end

endmodule