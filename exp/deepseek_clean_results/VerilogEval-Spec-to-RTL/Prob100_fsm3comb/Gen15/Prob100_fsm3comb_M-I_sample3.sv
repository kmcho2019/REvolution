module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// State encodings for better readability
localparam [1:0] A = 2'b00,
                 B = 2'b01,
                 C = 2'b10,
                 D = 2'b11;

// State transition logic
always @(*) begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
end

// Output is high only in state D (2'b11)
assign out = (state == D);

endmodule