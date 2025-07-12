module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg [1:0] state;    // one-hot encoded: state[0] = A, state[1] = B
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b01: begin // state A
            if (x) begin
                next_state = 2'b10; // go to B
                z = 1'b1;
            end else begin
                next_state = 2'b01; // stay in A
                z = 1'b0;
            end
        end
        2'b10: begin // state B
            next_state = 2'b10; // stay in B
            z = ~x ? 1'b1 : 1'b0;
        end
        default: begin
            next_state = 2'b01; // reset to A if invalid state
            z = 1'b0;
        end
    endcase
end

// state registers with async active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;  // reset to A
    else
        state <= next_state;
end

endmodule