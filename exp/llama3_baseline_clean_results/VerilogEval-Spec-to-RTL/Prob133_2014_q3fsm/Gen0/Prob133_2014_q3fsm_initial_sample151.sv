module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] counter; // counter for 3 clock cycles
reg [1:0] w_counter; // counter for w = 1 occurrences

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        counter <= 0;
        w_counter <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // move to state B
                    counter <= 1; // start counter
                    w_counter <= 0; // reset w_counter
                end
            end
            1: begin // state B
                if (counter < 3) begin
                    if (w) begin
                        w_counter <= w_counter + 1; // increment w_counter if w = 1
                    end
                    counter <= counter + 1; // increment counter
                end else begin
                    if (w_counter == 2) begin
                        z <= 1; // set z = 1 if w = 1 exactly twice
                    end else begin
                        z <= 0; // set z = 0 otherwise
                    end
                    counter <= 1; // reset counter
                    w_counter <= 0; // reset w_counter
                end
            end
        endcase
    end
end

endmodule