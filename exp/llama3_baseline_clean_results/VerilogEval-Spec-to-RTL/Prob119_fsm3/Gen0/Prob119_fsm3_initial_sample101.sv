module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states as enumerated values
localparam A = 0;
localparam B = 1;
localparam C = 2;
localparam D = 3;

// State register
reg [1:0] state, next_state;

// State transitions and output logic
always @(*)
begin
    case(state)
        A: begin
            next_state = (in) ? B : A;
            out = 0;
        end
        B: begin
            next_state = (in) ? B : C;
            out = 0;
        end
        C: begin
            next_state = (in) ? D : A;
            out = 0;
        end
        D: begin
            next_state = (in) ? B : C;
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

// State register update
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

endmodule