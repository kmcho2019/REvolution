module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state;
wire clk_enable;

always @(posedge clk)
    case (state)
'b00: // Idle state
            if (load)
                begin
                    counter <= data;
                    state <= 2'b01;
                end
            else
                state <= 2'b00;
'b01: // Counting state
            if (counter >'d0)
                begin
                    counter <= counter - 1;
                    state <= 2'b01;
                end
            else
                state <= 2'b10;
        2'b10: // Terminal count state
            if (load)
                begin
                    counter <= data;
                    state <= 2'b01;
                end
            else
                state <= 2'b10;
        default:
            state <= 2'b00;
    endcase

assign tc = (state == 2'b10);
assign clk_enable = (state == 2'b01);

endmodule