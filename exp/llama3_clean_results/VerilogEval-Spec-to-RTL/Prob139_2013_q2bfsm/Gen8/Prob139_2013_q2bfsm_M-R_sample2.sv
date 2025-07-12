module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] next_state;
reg [1:0] x_shift;
reg [1:0] next_x_shift;
reg [1:0] y_counter;
reg next_g;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_shift <= 0;
        y_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        x_shift <= next_x_shift;
        y_counter <= (state == 2)? y_counter + 1 : 0;
        f <= (state == 0)? 1 : 0;
        g <= next_g;
    end
end

assign next_state = (state == 0)? 1 :
                    (state == 1 && x_shift == 2'b101)? 2 :
                    (state == 2 && y)? 3 :
                    (state == 2 && y_counter >= 2)? 0 :
                    state;

assign next_x_shift = (state == 1)? {x, x_shift[0]} : 0;

assign next_g = (state == 2 && y)? 1 :
                (state == 2 && y_counter >= 2)? 0 :
                g;

endmodule