module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] acc;  // accumulated bits
reg [31:0] out_bits;  // output bits
reg [4:0] cnt;  // bit counter
reg sign;  // sign bit
reg [1:0] state;  // state register (0: idle, 1: convert, 2: done)

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;  // reset to idle state
        acc <= 0;
        out_bits <= 0;
        cnt <= 0;
        sign <= 0;
    end else begin
        case (state)
            0: begin  // idle state
                if (~areset) begin
                    state <= 1;  // transition to convert state when reset is released
                end
            end
            1: begin  // convert state
                acc <= {acc[30:0], x};  // accumulate input bits
                if (cnt == 0 && x == 1) begin  // if first bit is 1, set sign bit
                    sign <= 1;
                end
                cnt <= cnt + 1;
                if (cnt == 31) begin  // if all bits accumulated, transition to done state
                    if (sign) begin
                        out_bits <= ~(acc + 1);  // calculate 2's complement
                    end else begin
                        out_bits <= acc;
                    end
                    state <= 2;
                end
            end
            2: begin  // done state
                if (areset) begin  // if reset is asserted, return to idle state
                    state <= 0;
                end
                z <= out_bits[31 - cnt];  // output 2's complement bits
                cnt <= cnt - 1;
                if (cnt == 0) begin
                    state <= 0;  // return to idle state
                end
            end
        endcase
    end
end

endmodule