module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE  = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [2:0] counter;
    wire [15:0] next_p;

    // Booth encoding selection (combinational)
    assign next_p = 
        (multiplier[2:0] == 3'b000 || multiplier[2:0] == 3'b111) ? p :               // +0
        (multiplier[2:0] == 3'b001 || multiplier[2:0] == 3'b010) ? p + multiplicand : // +1
        (multiplier[2:0] == 3'b011)                  ? p + (multiplicand << 1) :     // +2
        (multiplier[2:0] == 3'b100)                  ? p - (multiplicand << 1) :     // -2
                                                        p - multiplicand;            // -1

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            counter <= 3'b0;
            state <= IDLE;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= COMPUTE;
                    rdy <= 1'b0;
                end
                
                COMPUTE: begin
                    if (counter < 4) begin
                        p <= next_p;
                        multiplicand <= multiplicand << 2;
                        multiplier <= multiplier >>> 2;
                        counter <= counter + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    rdy <= 1'b1;
                    state <= IDLE;  // Ready for next operation
                end
            endcase
        end
    end

endmodule