module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE  = 2'b10;

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [1:0] state;
    reg [1:0] counter;
    reg prev_lsb;
    reg [15:0] shifted_pp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            rdy <= 1'b0;
            state <= IDLE;
            counter <= 2'b0;
            prev_lsb <= 1'b0;
            shifted_pp <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Start computation
                    state <= COMPUTE;
                    counter <= 2'b0;
                    p <= 16'b0;
                    rdy <= 1'b0;
                end
                
                COMPUTE: begin
                    // Booth encoding and partial product selection
                    case ({multiplier[1:0], prev_lsb})
                        3'b000, 3'b111: shifted_pp <= 16'b0;
                        3'b001, 3'b010: shifted_pp <= multiplicand;
                        3'b011:         shifted_pp <= multiplicand << 1;
                        3'b100:         shifted_pp <= -(multiplicand << 1);
                        3'b101, 3'b110: shifted_pp <= -multiplicand;
                        default:       shifted_pp <= 16'b0;
                    endcase
                    
                    // Accumulate with proper shift
                    p <= p + (shifted_pp << (counter * 2));
                    
                    // Update multiplier and previous LSB
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[1];
                    
                    // Update counter and check completion
                    if (counter == 2'd3) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                DONE: begin
                    // Maintain output until reset
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule