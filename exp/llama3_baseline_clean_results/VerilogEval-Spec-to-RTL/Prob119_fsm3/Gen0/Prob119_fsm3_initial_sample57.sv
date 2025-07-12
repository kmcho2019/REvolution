module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
always @(*)
    begin
        case (current_state)
            A, B, C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

// Next state logic
always @(*)
    begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

// State register update
always @(posedge clk or posedge areset)
    begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule