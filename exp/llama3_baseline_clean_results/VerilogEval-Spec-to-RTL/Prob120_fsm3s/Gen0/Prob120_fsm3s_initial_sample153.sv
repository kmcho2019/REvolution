module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states as enumeration
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_type;

// Initialize state register
reg [1:0] state;

// Moore state machine
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic
always @(state) begin
    case (state)
        A, B, C: out <= 0;
        D: out <= 1;
        default: out <= 0;
    endcase
end

endmodule