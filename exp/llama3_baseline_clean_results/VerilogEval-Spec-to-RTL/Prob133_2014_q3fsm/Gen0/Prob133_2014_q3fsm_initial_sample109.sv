module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (0) and B (1, 2, 3)
reg [1:0] counter; // counter for 3 clock cycles
reg [1:0] w_count; // count of w highs

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // transition to state B
                    counter <= 1;
                    w_count <= 0;
                    z <= 0;
                end else begin
                    state <= 0; // stay in state A
                    z <= 0;
                end
            end
            1: begin // state B, first clock cycle
                counter <= counter + 1;
                if (w) begin
                    w_count <= w_count + 1;
                end
                z <= 0;
            end
            2: begin // state B, second clock cycle
                counter <= counter + 1;
                if (w) begin
                    w_count <= w_count + 1;
                end
                z <= 0;
            end
            3: begin // state B, third clock cycle
                if (w) begin
                    w_count <= w_count + 1;
                end
                if (w_count == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
                counter <= 1; // reset counter
                w_count <= 0; // reset w_count
            end
            default: begin
                state <= 0;
                counter <= 0;
                w_count <= 0;
                z <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (counter)
        1: state = 1;
        2: state = 2;
        3: state = 3;
        default: state = 0;
    endcase
end

endmodule