module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
reg [1:0] state; // 0: idle, 1: counting, 2: timed out
wire count_zero;

assign count_zero = (count == 10'd0);

always @(posedge clk)
    case (state)
        2'd0: // idle
            if (load)
                begin
                    state <= 2'd1;
                    count <= data;
                end
            else
                state <= 2'd0;
        2'd1: // counting
            if (count_zero)
                state <= 2'd2;
            else if (load)
                begin
                    state <= 2'd1;
                    count <= data;
                end
            else
                begin
                    state <= 2'd1;
                    count <= count - 1;
                end
        2'd2: // timed out
            if (load)
                begin
                    state <= 2'd1;
                    count <= data;
                end
            else
                state <= 2'd2;
    endcase

assign tc = (state == 2'd2);

endmodule