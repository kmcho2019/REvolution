module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // one-hot state encoding
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b01: begin // state A
            if (x == 0) begin
                next_state = 2'b01; // stay in A
                z = 0;
            end else begin
                next_state = 2'b10; // go to B
                z = 1;
            end
        end
        2'b10: begin // state B
            if (x == 0) begin
                next_state = 2'b10; // stay in B
                z = 1;
            end else begin
                next_state = 2'b10; // stay in B
                z = 0;
            end
        end
        default: begin // invalid state, reset to A
            next_state = 2'b01;
            z = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule