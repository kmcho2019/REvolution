module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // state A (2'b00) and state B (2'b01)
reg [1:0] counter; // counter for the clock cycles after entering state B
reg w_high_count; // counter for the number of times w is high
reg temp_z; // temporary variable to store the value of z

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset state machine to state A
        counter <= 2'b00; // reset counter
        w_high_count <= 1'b0; // reset w_high_count
        temp_z <= 1'b0; // reset temp_z
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01; // transition to state B
                    counter <= 2'b00; // reset counter
                    w_high_count <= 1'b0; // reset w_high_count
                end
            end
            2'b01: begin // state B
                counter <= counter + 1'b1; // increment counter
                if (w) begin
                    w_high_count <= w_high_count + 1'b1; // increment w_high_count if w is high
                end
                if (counter == 2'b11) begin // after three clock cycles
                    temp_z <= (w_high_count == 2'b10); // set temp_z to 1 if w was high exactly twice
                    counter <= 2'b00; // reset counter
                    w_high_count <= 1'b0; // reset w_high_count
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        z <= 1'b0; // reset z
    end else if (state == 2'b01 && counter == 2'b00) begin // set z after three clock cycles
        z <= temp_z; // set z to the value of temp_z
    end else begin
        z <= 1'b0; // otherwise, set z to 0
    end
end

endmodule