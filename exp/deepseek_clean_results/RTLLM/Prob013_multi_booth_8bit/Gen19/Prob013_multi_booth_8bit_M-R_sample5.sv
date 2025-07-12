module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg prev_lsb;
    reg [2:0] counter;

    // Combinational arithmetic operations
    wire [15:0] add_multi = p + multiplicand;
    wire [15:0] sub_multi = p - multiplicand;
    wire [15:0] add_2multi = p + (multiplicand << 1);
    wire [15:0] sub_2multi = p - (multiplicand << 1);

    // Booth encoding selection
    wire [2:0] booth_sel = {multiplier[1:0], prev_lsb};
    wire [15:0] next_p = 
        (booth_sel == 3'b001 || booth_sel == 3'b010) ? add_multi :
        (booth_sel == 3'b011) ? add_2multi :
        (booth_sel == 3'b100) ? sub_2multi :
        (booth_sel == 3'b101 || booth_sel == 3'b110) ? sub_multi :
        p;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            prev_lsb <= 1'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    rdy <= 1'b0;
                end
                
                CALC: begin
                    p <= next_p;
                    multiplicand <= multiplicand << 2;
                    prev_lsb <= multiplier[1];
                    multiplier <= multiplier >> 2;
                    
                    if (counter == 3) begin
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