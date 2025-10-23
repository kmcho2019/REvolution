module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg [1:0] state, next_state;
// One-hot encoding
localparam A = 2'b01;
localparam B = 2'b10;

always @(*) begin
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
            next_state = B;
            z = (x == 1'b0) ? 1'b1 : 1'b0;
        end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule