module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] sum; // Assuming a 32-bit number
reg [4:0] state; // 5 states: idle, wait, and 3 states for handling overflow
reg sign;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // idle state
        sum <= 0;
        sign <= 0;
    end else begin
        case(state)
            0: begin // idle state
                state <= 1; // move to wait state
            end
            1: begin // wait state
                if (x == 1) begin
                    sum <= ~sum + 1; // invert and add 1
                    sign <= 1; // set sign bit
                end else begin
                    sum <= {sum[30:0], x}; // shift left
                end
                z <= sum[0]; // output current bit
            end
            default: state <= 0; // handle overflow
        endcase
    end
end

endmodule