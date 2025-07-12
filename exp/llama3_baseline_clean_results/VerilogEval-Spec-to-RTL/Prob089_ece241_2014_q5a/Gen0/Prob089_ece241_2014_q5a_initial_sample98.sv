module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // idle (2'b00), conversion (2'b01)
reg carry;
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // idle
            if (!areset)
                next_state = 2'b01;
            else
                next_state = 2'b00;
            z = 1'b0;
            carry = 1'b0;
        end
        2'b01: begin // conversion
            if (areset)
                next_state = 2'b00;
            else
                next_state = 2'b01;
            z = ~(x ^ carry);
            carry = ~carry & x;
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule