module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

// State encoding
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [3:0] cycle;      // 0-7 cycles for radix-4 (16/2)
reg [15:0] multiplicand;
reg [16:0] multiplier; // Extra bit for sign extension
reg [31:0] accumulator;

// Booth encoder outputs
wire [1:0] booth_sel;
wire [31:0] partial_product;
wire [4:0] shift_amount;

assign booth_sel = multiplier[1:0];
assign shift_amount = {cycle, 1'b0}; // Multiply cycle by 2 for radix-4 shift

// Booth encoding and partial product generation
always @(*) begin
    case (booth_sel)
        2'b00, 2'b11: partial_product = 32'b0;
        2'b01: partial_product = {{16{1'b0}}, multiplicand} << shift_amount;
        2'b10: partial_product = {{16{1'b0}}, ~multiplicand + 1'b1} << shift_amount;
    endcase
end

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cycle <= 4'b0;
        multiplicand <= 16'b0;
        multiplier <= 17'b0;
        accumulator <= 32'b0;
        yout <= 32'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= CALC;
                    multiplicand <= ain;
                    multiplier <= {bin, 1'b0}; // Append 0 for initial Booth pair
                    accumulator <= 32'b0;
                    cycle <= 4'b0;
                end
            end
            
            CALC: begin
                accumulator <= accumulator + partial_product;
                multiplier <= multiplier >> 2; // Shift right by 2 for next radix-4 digit
                
                if (cycle == 4'd7) begin
                    state <= DONE;
                    yout <= accumulator + partial_product;
                end
                else begin
                    cycle <= cycle + 1;
                end
            end
            
            DONE: begin
                if (!start) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign done = (state == DONE);

endmodule