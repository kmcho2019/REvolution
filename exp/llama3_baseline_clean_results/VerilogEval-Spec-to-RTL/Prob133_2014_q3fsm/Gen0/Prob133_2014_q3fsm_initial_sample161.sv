module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] counter; // Counter for 3 cycles
reg w_count; // Counter for w = 1 occurrences
reg [1:0] next_state;

always @(*) begin
    case (state)
        0: begin // State A
            if (s == 1) next_state = 1;
            else next_state = 0;
            if (next_state == 1) begin
                counter = 0;
                w_count = 0;
            end
        end
        1: begin // State B
            next_state = 1; // Stay in State B
            if (counter < 2) begin
                counter = counter + 1;
                if (w == 1) w_count = w_count + 1;
            end else begin
                counter = 0;
                if (w_count == 2) z = 1;
                else z = 0;
                w_count = 0;
                if (w == 1) w_count = 1;
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state = 0;
        z = 0;
        counter = 0;
        w_count = 0;
    end else begin
        state = next_state;
    end
end

endmodule