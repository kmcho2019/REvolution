module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

localparam [1:0]
    A = 2'b01,
    B = 2'b10;

reg [1:0] state, next_state;

// Next state logic
assign next_state = (state == A) ? (x ? B : A) :
                    (state == B) ? B :
                    A; // default to A for safety

// Output logic (Mealy)
assign z = (state == A) ? x :
           (state == B) ? ~x :
           1'b0; // default output

// State register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule