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
    reg [4:0] ctr;
    reg [1:0] prev_lsb; // Stores previous LSB for Booth encoding

    // Booth encoding states
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign-extended inputs
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
            prev_lsb <= 2'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    state <= CALC;
                    ctr <= 5'b0;
                    prev_lsb <= 2'b0;
                end
                
                CALC: begin
                    if (ctr < 8) begin
                        // Examine 3 bits (current pair + previous LSB)
                        case ({multiplier[1:0], prev_lsb[0]})
                            3'b000, 3'b111: begin // No operation
                                p <= p;
                            end
                            3'b001, 3'b010: begin // Add multiplicand
                                p <= p + (multiplicand << (2*ctr));
                            end
                            3'b011: begin // Add 2*multiplicand
                                p <= p + ((multiplicand << 1) << (2*ctr));
                            end
                            3'b100: begin // Subtract 2*multiplicand
                                p <= p - ((multiplicand << 1) << (2*ctr));
                            end
                            3'b101, 3'b110: begin // Subtract multiplicand
                                p <= p - (multiplicand << (2*ctr));
                            end
                        endcase
                        
                        // Shift multiplier right by 2 bits for next group
                        multiplier <= multiplier >> 2;
                        prev_lsb <= multiplier[1:0];
                        ctr <= ctr + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule