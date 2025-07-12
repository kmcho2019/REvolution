module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values using binary encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// Next state logic
always @(*) begin
    case (state)
        A: state <= in? B : A;
        B: state <= in? B : C;
        C: state <= in? D : A;
        D: state <= in? B : C;
        default: state <= A;
    endcase
end

// Output logic
assign out = (state == D)? 1 : 0;

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        reg [1:0] next_state;
        always @(*) begin
            case (state)
                A: next_state = in? B : A;
                B: next_state = in? B : C;
                C: next_state = in? D : A;
                D: next_state = in? B : C;
                default: next_state = A;
            endcase
        end
        state <= next_state;
    end
end

endmodule