module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: state A, 1: state B, 2: checking w, 3: set z
reg [1:0] counter; // counter for three clock cycles
reg [1:0] w_counter; // counter for w being high
reg temp_z; // temporary output

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // reset to state A
        counter <= 0;
        w_counter <= 0;
        temp_z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // transition to state B
                    counter <= 1;
                    w_counter <= w ? 1 : 0;
                    temp_z <= 0;
                end else begin
                    state <= 0;
                    counter <= 0;
                    w_counter <= 0;
                    temp_z <= 0;
                end
            end
            1: begin // state B
                counter <= counter + 1;
                w_counter <= w_counter + (w ? 1 : 0);
                if (counter == 3) begin
                    state <= 2; // transition to checking w
                end
            end
            2: begin // checking w
                temp_z <= (w_counter == 2) ? 1 : 0;
                state <= 3; // transition to set z
            end
            3: begin // set z
                z <= temp_z;
                state <= 1; // transition back to state B
                counter <= 1;
                w_counter <= w ? 1 : 0;
            end
        endcase
    end
end

endmodule