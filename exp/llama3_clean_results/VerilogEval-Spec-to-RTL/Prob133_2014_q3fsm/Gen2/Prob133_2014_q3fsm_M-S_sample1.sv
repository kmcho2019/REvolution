module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2'b00: state A, 2'b01: state B, 2'b10: state C
reg [1:0] counter; // counter for 3 clock cycles
reg w_count; // count of w being 1 in 3 clock cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // reset to state A
        counter <= 2'b00;
        w_count <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // state A
                if(s) begin
                    state <= 2'b01; // transition to state B
                    counter <= 2'b01;
                    w_count <= 1'b0;
                end
            end
            2'b01: begin // state B
                if(counter == 2'b11) begin
                    state <= 2'b10; // transition to state C
                    z <= (w_count == 1'b1)? 1'b1 : 1'b0; // set output z
                end else begin
                    if(w) begin
                        w_count <= w_count + 1'b1;
                    end
                    counter <= counter + 1'b1;
                end
            end
            2'b10: begin // state C
                state <= 2'b01; // transition back to state B
                counter <= 2'b01;
                w_count <= 1'b0;
            end
        endcase
    end
end

endmodule