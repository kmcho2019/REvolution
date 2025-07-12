module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding
// A = 2'b01, B = 2'b10
reg [1:0] state, next_state;

// State encoding parameters for clarity
localparam A = 2'b01;
localparam B = 2'b10;

// Next state and output logic (Mealy)
always @(*) begin
    case (state)
        A: begin
            if (x == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            next_state = B;
        end
        default: next_state = A;
    endcase
end

// Output logic (z) depends on state and input x
assign z = (state == A) ? (x == 1'b1) :
           (state == B) ? (x == 1'b0) :
           1'b0;

// Asynchronous active-high reset, state register on posedge clk
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule