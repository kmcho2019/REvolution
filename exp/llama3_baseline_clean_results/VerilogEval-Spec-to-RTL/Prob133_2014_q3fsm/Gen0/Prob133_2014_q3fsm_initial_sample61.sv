module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] counter; // counter for 3 clock cycles
reg w_count; // count of w = 1
reg flag; // flag to set z to 1

initial begin
    state = 2'b00; // initial state A
    counter = 2'b00;
    w_count = 1'b0;
    flag = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state = 2'b00; // reset to state A
        counter = 2'b00;
        w_count = 1'b0;
        flag = 1'b0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state = 2'b01; // transition to state B
                    counter = 2'b01;
                    w_count = 1'b0;
                    flag = 1'b0;
                end
            end
            2'b01: begin // state B
                if (w) begin
                    w_count = w_count + 1'b1;
                end
                if (counter == 2'b11) begin
                    state = 2'b10; // transition to state C
                    flag = (w_count == 2'b10);
                    counter = 2'b00;
                    w_count = 1'b0;
                end else begin
                    counter = counter + 1'b1;
                end
            end
            2'b10: begin // state C
                state = 2'b01; // transition to state B
            end
        endcase
    end
end

always @(posedge clk) begin
    if (flag) begin
        z = 1'b1;
        flag = 1'b0;
    end else begin
        z = 1'b0;
    end
end

endmodule