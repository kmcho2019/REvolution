module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable (A=0, B=1, with B potentially being further divided based on w count)
reg [2:0] w_count; // Counter for w=1 occurrences over 3 cycles
reg [2:0] cycle_count; // Counter for the 3 cycles

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        cycle_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Move to state B
                    w_count <= 0;
                    cycle_count <= 0;
                end
            end
            1: begin // State B
                cycle_count <= cycle_count + 1;
                if(w) begin
                    w_count <= w_count + 1;
                end
                if(cycle_count == 3) begin // End of 3 cycles
                    if(w_count == 2) begin
                        z <= 1; // Set z to 1 if exactly 2 w=1 occurrences
                    end else begin
                        z <= 0;
                    end
                    cycle_count <= 0; // Reset cycle count
                    w_count <= 0; // Reset w count
                end
            end
        endcase
    end
end

endmodule