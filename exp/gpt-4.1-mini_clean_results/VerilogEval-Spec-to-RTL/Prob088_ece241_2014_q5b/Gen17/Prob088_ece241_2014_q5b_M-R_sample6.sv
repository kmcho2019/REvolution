module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// State encoding - one-hot
localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Next state and output logic
always @(*) begin
    next_state = state;
    z = 1'b0;
    case (state)
        A: begin
            if (x == 1'b0) begin
                next_state = A;
                z = 1'b0;
            end else begin
                next_state = B;
                z = 1'b1;
            end
        end
        B: begin
            if (x == 1'b0) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = B;
                z = 1'b0;
            end
        end
        default: begin
            next_state = A; // recover to A on invalid state
            z = 1'b0;
        end
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule