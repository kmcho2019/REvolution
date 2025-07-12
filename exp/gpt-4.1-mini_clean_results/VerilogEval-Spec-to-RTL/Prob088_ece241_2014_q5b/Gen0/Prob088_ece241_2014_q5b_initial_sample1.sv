module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// One-hot encoded states
localparam A = 2'b01,
           B = 2'b10;

reg [1:0] state, next_state;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Next state logic and output logic (Mealy)
always @(*) begin
    case(state)
        A: begin
            if (x) begin
                next_state = B;
                z = 1;
            end else begin
                next_state = A;
                z = 0;
            end
        end
        B: begin
            next_state = B;
            if (x)
                z = 0;
            else
                z = 1;
        end
        default: begin
            next_state = A;
            z = 0;
        end
    endcase
end

endmodule