module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // 0: idle, 1: counting, 2: done
assign tc = (state == 2);

always @(posedge clk)
    case (state)
        0: // idle
            if (load)
                begin
                    counter <= data;
                    state <= 1;
                end
            else
                state <= 0;
        1: // counting
            if (counter > 0)
                begin
                    counter <= counter - 1;
                    state <= 1;
                end
            else
                state <= 2;
        2: // done
            if (load)
                begin
                    counter <= data;
                    state <= 1;
                end
            else
                state <= 2;
    endcase

endmodule