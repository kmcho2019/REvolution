module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // A = 0, B = 1, B1 = 2 (intermediate states for counting w)
reg [1:0] counter; // counts w = 1 occurrences
reg [1:0] clock_counter; // counts clock cycles in state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // A
        counter <= 0;
        clock_counter <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // A
                if (s) begin
                    state <= 1; // B
                    counter <= 0;
                    clock_counter <= 0;
                end
            end
            1: begin // B
                if (w) begin
                    counter <= counter + 1;
                end
                clock_counter <= clock_counter + 1;
                if (clock_counter == 2) begin
                    if (counter == 2) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    state <= 1; // stay in B
                    counter <= 0;
                    clock_counter <= 0;
                end
            end
        endcase
    end
end

endmodule