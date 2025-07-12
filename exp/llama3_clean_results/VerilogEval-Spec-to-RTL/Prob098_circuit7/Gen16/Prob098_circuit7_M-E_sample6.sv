module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] state;

always @(posedge clk) 
    case (state)
        2'b00: // S0
            if (!a) 
                state <= 2'b00;
            else 
                state <= 2'b01;
        2'b01: // S1
            if (a) 
                state <= 2'b01;
            else 
                state <= 2'b00;
        default: 
            state <= 2'b00;
    endcase

always @(posedge clk) 
    case (state)
        2'b00: // S0
            q <= 1'b1;
        2'b01: // S1
            q <= 1'b0;
        default: 
            q <= 1'b1;
    endcase

initial 
    state <= 2'b00;

endmodule