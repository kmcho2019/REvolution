module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding:
    // 00 - State A
    // 01 - State B, cycle 1
    // 10 - State B, cycle 2
    // 11 - State B, cycle 3
    reg [1:0] state;
    
    // Count of 1's in current window
    reg [1:0] w_count;
    
    // Output is combinatorial
    assign z = (state == 2'b11) && (w_count == 2'd2);
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            w_count <= 2'b0;
        end else begin
            case (state)
                2'b00: begin // State A
                    if (s) begin
                        state <= 2'b01; // Move to B, cycle 1
                        w_count <= w ? 2'd1 : 2'd0;
                    end
                end
                
                2'b01: begin // B, cycle 1
                    state <= 2'b10;
                    w_count <= w_count + (w ? 2'd1 : 2'd0);
                end
                
                2'b10: begin // B, cycle 2
                    state <= 2'b11;
                    w_count <= w_count + (w ? 2'd1 : 2'd0);
                end
                
                2'b11: begin // B, cycle 3
                    state <= 2'b01; // Start new window
                    w_count <= w ? 2'd1 : 2'd0;
                end
            endcase
        end
    end

endmodule