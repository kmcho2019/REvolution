module TopModule(clk, reset, s, w, z);
    input clk, reset, s, w;
    output z;
    reg [1:0] state; // 0 - A, 1 - B, 2 - count_w, 3 - set_z
    reg [1:0] count; // Counter for 'w' in state B
    reg [2:0] cycle; // Counter for three cycles in state B
    reg temp_z; // Temporary variable for 'z'

    always @(posedge clk) begin
        if(reset) begin
            state <= 0; // Reset to state A
            count <= 0;
            cycle <= 0;
            temp_z <= 0;
            z <= 0;
        end
        else begin
            case(state)
                0: begin // State A
                    if(s) begin
                        state <= 1; // Move to state B
                    end
                    z <= 0; // 'z' should be 0 in state A
                end
                1: begin // State B
                    if(w) begin
                        count <= count + 1;
                    end
                    cycle <= cycle + 1;
                    if(cycle == 2) begin // End of three cycles
                        if(count == 2) begin
                            temp_z <= 1; // Set 'z' to 1 if 'w' was 1 exactly twice
                        end
                        else begin
                            temp_z <= 0;
                        end
                        state <= 2; // Move to set_z state
                    end
                end
                2: begin // Set_z state
                    z <= temp_z; // Set 'z'
                    state <= 3; // Move to next state
                end
                3: begin // Reset counters and move back to state B
                    count <= 0;
                    cycle <= 0;
                    temp_z <= 0;
                    state <= 1; // Back to state B to check 'w' again
                end
            endcase
        end
    end
endmodule