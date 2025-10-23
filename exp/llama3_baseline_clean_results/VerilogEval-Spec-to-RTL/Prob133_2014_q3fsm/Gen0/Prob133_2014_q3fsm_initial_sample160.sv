module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: state A, 1: state B
reg [1:0] counter; // counter for clock cycles in state B
reg w_counter; // counter for w = 1 in state B
reg [1:0] next_state;
reg [1:0] next_counter;
reg next_w_counter;
reg next_z;

always @(*) begin
    case(state)
        0: begin // state A
            if (s) begin
                next_state = 1;
                next_counter = 0;
                next_w_counter = 0;
            end else begin
                next_state = 0;
                next_counter = 0;
                next_w_counter = 0;
            end
            next_z = 0;
        end
        1: begin // state B
            next_counter = counter + 1;
            if (w) begin
                next_w_counter = w_counter + 1;
            end else begin
                next_w_counter = w_counter;
            end
            if (counter == 2) begin // check after 3 clock cycles
                if (w_counter == 2) begin
                    next_z = 1;
                end else begin
                    next_z = 0;
                end
                next_state = 1;
                next_counter = 0;
                next_w_counter = 0;
            end else begin
                next_z = 0;
                next_state = 1;
            end
        end
        default: begin
            next_state = 0;
            next_counter = 0;
            next_w_counter = 0;
            next_z = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        w_counter <= 0;
        z <= 0;
    end else begin
        state <= next_state;
        counter <= next_counter;
        w_counter <= next_w_counter;
        z <= next_z;
    end
end

endmodule