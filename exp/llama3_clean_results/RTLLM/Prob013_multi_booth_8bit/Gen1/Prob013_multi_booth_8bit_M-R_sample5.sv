module multi_booth_8bit(
    input clk, 
    input reset, 
    input [7:0] a, 
    input [7:0] b, 
    output reg [15:0] p, 
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [4:0] ctr;
reg [1:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        p <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0; // IDLE state
    end else begin
        case (state)
            0: begin // IDLE state
                if (!reset) begin
                    state <= 1; // RUNNING state
                end
            end
            1: begin // RUNNING state
                if (ctr < 16) begin
                    multiplicand <= multiplicand << 1;
                    if (multiplier[ctr] == 1) begin
                        p <= p + multiplicand;
                    end
                    ctr <= ctr + 1;
                    if (ctr == 16) begin
                        rdy <= 1;
                        state <= 0; // IDLE state
                    end
                end
            end
        endcase
    end
end

endmodule