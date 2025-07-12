module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [3:0] counter;
    reg [1:0] state;

    localparam COMPUTE = 1'b0;
    localparam DONE   = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            rdy <= 1'b0;
            counter <= 4'b0;
            state <= COMPUTE;
        end else begin
            case (state)
                COMPUTE: begin
                    // Booth encoding and partial product accumulation
                    case (multiplier[1:0])
                        2'b01: p <= p + (multiplicand << (counter*2));
                        2'b10: p <= p - (multiplicand << (counter*2));
                        default: p <= p; // 00 or 11: no operation
                    endcase

                    // Arithmetic right shift multiplier by 2 (Radix-4)
                    multiplier <= $signed(multiplier) >>> 2;

                    if (counter == 4'd3) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                DONE: begin
                    rdy <= 1'b1; // Maintain ready signal
                end
            endcase
        end
    end

endmodule