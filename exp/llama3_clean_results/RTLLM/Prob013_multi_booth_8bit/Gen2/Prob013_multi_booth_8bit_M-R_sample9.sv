module multi_booth_8bit(
    input clk, 
    input reset, 
    input [7:0] a, 
    input [7:0] b, 
    output reg [15:0] p, 
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [4:0] ctr;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam MULT = 2'b01;

// Combinational logic
assign multiplicand_next = (state == MULT) ? multiplicand << 1 : (reset) ? { {8{b[7]}}, b } : multiplicand;
assign p_next = (state == MULT && multiplier[ctr] == 1) ? p + multiplicand : (reset) ? 0 : p;
assign ctr_next = (state == MULT) ? ctr + 1 : (reset) ? 0 : ctr;
assign rdy_next = (ctr == 16) ? 1 : (reset) ? 0 : rdy;
assign state_next = (reset) ? IDLE : (state == IDLE && ~reset) ? MULT : (state == MULT && ctr == 16) ? IDLE : state;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= { {8{a[7]}}, a };
        multiplicand <= { {8{b[7]}}, b };
        p <= 0;
        ctr <= 0;
        state <= IDLE;
        rdy <= 0;
    end else begin
        multiplicand <= multiplicand_next;
        p <= p_next;
        ctr <= ctr_next;
        state <= state_next;
        rdy <= rdy_next;
    end
end

endmodule