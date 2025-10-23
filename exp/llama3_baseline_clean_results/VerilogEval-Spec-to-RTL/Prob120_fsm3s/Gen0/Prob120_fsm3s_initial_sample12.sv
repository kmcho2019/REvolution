module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] current_state;
reg [1:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A; // Default state
    endcase
end

always @(*) begin
    case(current_state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0; // Default output
    endcase
end

endmodule