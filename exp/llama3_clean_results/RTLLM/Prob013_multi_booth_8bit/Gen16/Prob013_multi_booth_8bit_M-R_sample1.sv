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
reg [1:0] state;
reg start;

localparam IDLE = 2'b00;
localparam MULT = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        p <= 0;
        ctr <= 0;
        state <= IDLE;
        rdy <= 0;
        start <= 1;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= MULT;
                end
            end
            MULT: begin
                if (ctr < 16) begin
                    if (multiplier[ctr]) begin
                        p <= p + multiplicand;
                    end
                    multiplicand <= multiplicand << 1;
                    ctr <= ctr + 1;
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                rdy <= 1;
                state <= IDLE;
                start <= 0;
            end
        endcase
    end
end

endmodule