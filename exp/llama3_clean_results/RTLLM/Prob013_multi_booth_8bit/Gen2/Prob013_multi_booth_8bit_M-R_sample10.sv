module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [1:0] state; // 0: reset, 1: multiply, 2: done

always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        p <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
    end else begin
        case(state)
            0: begin // Reset
                multiplicand <= { {8{b[7]}}, b };
                multiplier <= { {8{a[7]}}, a };
                p <= 0;
                ctr <= 0;
                rdy <= 0;
                state <= 1;
            end
            1: begin // Multiply
                multiplicand <= multiplicand << 1;
                if(multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                ctr <= ctr + 1;
                if(ctr >= 16) begin
                    state <= 2;
                end
            end
            2: begin // Done
                rdy <= 1;
            end
        endcase
    end
end

endmodule