module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (2'b00), B (2'b01), B1 (2'b10), B2 (2'b11)
reg [1:0] counter; // counter for the three clock cycles
reg [1:0] w_count; // counter for the number of 1s in the three clock cycles
reg z_reg; // register to hold the output z

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset state to A
        counter <= 2'b00;
        w_count <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b10; // move to state B1
                end
            end
            2'b10: begin // state B1
                w_count <= w? 1'b1 : 1'b0;
                counter <= 1'b1;
                state <= 2'b11; // move to state B2
            end
            2'b11: begin // state B2
                if (w) begin
                    w_count <= w_count + 1'b1;
                end
                counter <= counter + 1'b1;
                if (counter == 2'b10) begin // three clock cycles completed
                    if (w_count == 2'b10) begin // exactly two 1s in the three clock cycles
                        z_reg <= 1'b1;
                    end else begin
                        z_reg <= 1'b0;
                    end
                    w_count <= 2'b00; // reset w_count
                    counter <= 2'b00; // reset counter
                    state <= 2'b10; // move back to state B1
                end else begin
                    state <= 2'b11; // stay in state B2
                end
            end
            default: state <= 2'b00; // default state
        endcase
    end
end

always @ (posedge clk) begin
    if (reset) begin
        z <= 1'b0;
    end else begin
        z <= z_reg;
    end
end

endmodule