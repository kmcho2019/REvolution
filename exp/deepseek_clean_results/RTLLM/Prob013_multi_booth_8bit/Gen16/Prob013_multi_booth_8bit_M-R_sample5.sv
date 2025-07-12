module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    localparam CALC = 1'b0;
    localparam DONE = 1'b1;
    reg state;

    // Internal registers (optimized to 9 bits)
    reg [8:0] multiplicand;
    reg [8:0] multiplier;
    reg prev_lsb;
    reg [2:0] iter_ctr;

    // Booth operation signals
    wire [15:0] booth_add = {7'b0, multiplicand};
    wire [15:0] booth_sub = -{7'b0, multiplicand};
    wire [15:0] booth_add2 = booth_add << 1;
    wire [15:0] booth_sub2 = booth_sub << 1;

    // Booth encoding selection
    wire [15:0] booth_result = 
        ({multiplier[1:0], prev_lsb} == 3'b000 || {multiplier[1:0], prev_lsb} == 3'b111) ? 16'b0 :
        ({multiplier[1:0], prev_lsb} == 3'b001 || {multiplier[1:0], prev_lsb} == 3'b010) ? booth_add :
        ({multiplier[1:0], prev_lsb} == 3'b101 || {multiplier[1:0], prev_lsb} == 3'b110) ? booth_sub :
        ({multiplier[1:0], prev_lsb} == 3'b011) ? booth_add2 :
        ({multiplier[1:0], prev_lsb} == 3'b100) ? booth_sub2 : 16'b0;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= CALC;
            multiplicand <= {a[7], a};
            multiplier <= {b[7], b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            iter_ctr <= 3'b0;
            rdy <= 1'b0;
        end else begin
            case (state)
                CALC: begin
                    p <= p + booth_result;
                    multiplicand <= multiplicand << 2;
                    prev_lsb <= multiplier[1];
                    multiplier <= {multiplier[8], multiplier[8:2]}; // Arithmetic right shift
                    
                    if (iter_ctr == 3'd4) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end else begin
                        iter_ctr <= iter_ctr + 1;
                    end
                end
                
                DONE: begin
                    // Maintain state until next reset
                    state <= DONE;
                end
            endcase
        end
    end

endmodule