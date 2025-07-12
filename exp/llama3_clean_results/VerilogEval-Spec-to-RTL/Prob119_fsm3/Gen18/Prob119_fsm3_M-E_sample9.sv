module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values using gray code encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b11;
localparam D = 2'b10;

// State register
reg [1:0] state;

// Next-state logic
always_comb begin
    case (state)
        A: state_next = in ? B : A;
        B: state_next = in ? B : C;
        C: state_next = in ? D : A;
        D: state_next = in ? B : C;
        default: state_next = A;
    endcase
end

reg [1:0] state_next;

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= state_next;
    end
end

endmodule