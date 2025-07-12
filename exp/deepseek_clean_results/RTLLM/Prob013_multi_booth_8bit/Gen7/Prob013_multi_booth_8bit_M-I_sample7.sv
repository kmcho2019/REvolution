module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;
    
    reg state;
    reg [2:0] count;      // Iteration counter (0-3)
    reg [7:0] multiplicand;
    reg [8:0] multiplier; // Multiplier with extra bit (Q)
    reg q_prev;           // Previous LSB for Booth encoding
    
    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            state <= IDLE;
            p <= 16'b0;
            rdy <= 1'b0;
            count <= 3'b0;
            multiplicand <= a;
            multiplier <= {b, 1'b0};
            q_prev <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Start multiplication
                    state <= BUSY;
                    p <= 16'b0;
                    rdy <= 1'b0;
                    count <= 3'b0;
                    multiplicand <= a;
                    multiplier <= {b, 1'b0};
                    q_prev <= 1'b0;
                end
                
                BUSY: begin
                    if (count < 4) begin
                        // Booth encoding and operation
                        case ({multiplier[1:0], q_prev})
                            3'b000, 3'b111: ; // No operation
                            3'b001, 3'b010: p <= p + {{8{multiplicand[7]}}, multiplicand};
                            3'b101, 3'b110: p <= p - {{8{multiplicand[7]}}, multiplicand};
                            3'b011: p <= p + ({{8{multiplicand[7]}}, multiplicand} << 1);
                            3'b100: p <= p - ({{8{multiplicand[7]}}, multiplicand} << 1);
                        endcase
                        
                        // Arithmetic right shift
                        {multiplier, q_prev} <= {multiplier[8], multiplier[8:1]};
                        count <= count + 1;
                    end else begin
                        // Multiplication complete
                        state <= IDLE;
                        rdy <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule