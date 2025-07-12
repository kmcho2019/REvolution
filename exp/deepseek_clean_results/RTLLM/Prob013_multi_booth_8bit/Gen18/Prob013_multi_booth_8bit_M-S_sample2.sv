module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [2:0] multiplier; // [1:0] for current bits, [2] for prev_lsb
    reg [1:0] counter;
    
    always @(posedge clk) begin
        if (reset) begin
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {1'b0, b[1:0]};
            counter <= 2'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            case (multiplier)
                3'b001, 3'b010: p <= p + multiplicand;
                3'b011:         p <= p + (multiplicand << 1);
                3'b100:         p <= p - (multiplicand << 1);
                3'b101, 3'b110: p <= p - multiplicand;
            endcase
            
            multiplicand <= multiplicand << 2;
            multiplier <= {b[2*counter+1], b[2*counter+2], multiplier[1]};
            rdy <= (counter == 2'b11);
            counter <= counter + 1;
        end
    end

endmodule