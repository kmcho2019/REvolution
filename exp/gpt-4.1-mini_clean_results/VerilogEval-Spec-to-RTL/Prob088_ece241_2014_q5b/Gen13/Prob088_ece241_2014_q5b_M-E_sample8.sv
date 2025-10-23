module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded state vector: 2'b01 = A, 2'b10 = B
reg [1:0] state, next_state;

localparam A = 2'b01;
localparam B = 2'b10;

// Next state and output logic combined (combinational)
always @(*) begin
    case (state)
        A: begin
            if (x) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = A;
                z = 1'b0;
            end
        end
        B: begin
            next_state = B;
            if (x)
                z = 1'b0;
            else
                z = 1'b1;
        end
        default: begin
            next_state = A;
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