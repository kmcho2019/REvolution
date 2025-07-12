module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding: WAIT(0), GOT1(1), GOT11(2), GOT110(3)
    reg [1:0] state;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            found <= 1'b0;
        end else if (!found) begin
            case (state)
                2'b00: state <= (data) ? 2'b01 : 2'b00; // Wait for first '1'
                2'b01: state <= (data) ? 2'b10 : 2'b00; // Got '1', wait for second '1'
                2'b10: state <= (data) ? 2'b10 : 2'b11; // Got "11", wait for '0'
                2'b11: begin
                    if (data) begin       // Got "110", check for final '1'
                        found <= 1'b1;   // Complete sequence found
                        state <= 2'b00;  // Reset state (optional)
                    end else begin
                        state <= 2'b00;   // Wrong bit, restart
                    end
                end
            endcase
        end
    end

    assign start_shifting = found;

endmodule