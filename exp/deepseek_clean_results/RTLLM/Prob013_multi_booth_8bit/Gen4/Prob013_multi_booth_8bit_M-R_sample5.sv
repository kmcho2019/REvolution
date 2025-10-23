module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

    // State definitions
    localparam IDLE  = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] ctr;
    reg prev_lsb;

    // Ready signal is combinational
    assign rdy = (state == DONE);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 5'b0;
            prev_lsb <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= COMPUTE;
                    ctr <= 5'b0;
                end

                COMPUTE: begin
                    // Booth Radix-4 operation
                    case ({multiplier[1:0], prev_lsb})
                        3'b000, 3'b111: p <= p;
                        3'b001, 3'b010: p <= p + multiplicand;
                        3'b011:         p <= p + (multiplicand << 1);
                        3'b100:         p <= p - (multiplicand << 1);
                        3'b101, 3'b110: p <= p - multiplicand;
                    endcase

                    // Update registers
                    multiplier <= {multiplier[15], multiplier[15:1]};
                    prev_lsb <= multiplier[0];
                    ctr <= ctr + 1;

                    // State transition
                    if (ctr == 15) state <= DONE;
                end

                DONE: begin
                    // Maintain final state until reset
                    state <= DONE;
                end
            endcase
        end
    end

endmodule