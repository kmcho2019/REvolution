module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg [1:0] count; // [1] = cycle count MSB, [0] = ones count LSB

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'b00;
        end else begin
            case (state)
                STATE_A: begin
                    if (s) begin
                        state <= STATE_B;
                        count <= {1'b0, w}; // Start counting
                    end
                end
                STATE_B: begin
                    if (count[1]) begin // End of 3-cycle window
                        count <= {1'b0, w}; // Reset cycle count, start new count
                    end else begin
                        count <= {count[1] + 1'b1, count[0] + w}; // Increment both
                    end
                end
            endcase
        end
    end

    // z is high when we're at start of new window and previous window had exactly two 1's
    assign z = (state == STATE_B) && (count[1]) && (count[0] == 1'b1);

endmodule