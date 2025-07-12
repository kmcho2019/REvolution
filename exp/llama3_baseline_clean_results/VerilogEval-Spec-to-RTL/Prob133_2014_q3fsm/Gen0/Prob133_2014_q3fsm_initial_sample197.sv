module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register: 2 states (A, B)
reg [1:0] counter; // Counter for w = 1 in state B
reg [1:0] clock_cycle; // Clock cycle counter in state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state is A (state = 0)
        counter <= 0;
        clock_cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    counter <= 0;
                    clock_cycle <= 0;
                end
            end
            1: begin // State B
                if (w) begin
                    counter <= counter + 1;
                end
                clock_cycle <= clock_cycle + 1;
                if (clock_cycle == 2) begin // After three cycles, decide z
                    if (counter == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                end else if (clock_cycle == 3) begin // Reset counter and clock cycle
                    counter <= 0;
                    clock_cycle <= 0;
                end
            end
        endcase
    end
end

endmodule