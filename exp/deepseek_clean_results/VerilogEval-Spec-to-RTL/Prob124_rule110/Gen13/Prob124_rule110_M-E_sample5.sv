module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [1:0] state;  // FSM state
    reg [2:0] shift_reg;  // 3-bit shift register (left, center, right)
    reg [8:0] counter;  // 9-bit counter (512 states)
    wire next_bit;

    // Optimized Rule 110 logic
    assign next_bit = (~shift_reg[2] & (shift_reg[1] | shift_reg[0])) | 
                     (shift_reg[2] & shift_reg[1] & ~shift_reg[0]);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            state <= 0;
            counter <= 0;
        end else begin
            case (state)
                0: begin  // Load stage
                    if (counter == 0) begin
                        shift_reg <= {q[0], 1'b0, 1'b0};  // Insert boundary
                    end else if (counter == 511) begin
                        shift_reg <= {1'b0, q[511], q[510]};  // Insert boundary
                    end else begin
                        shift_reg <= {q[counter], q[counter-1], (counter > 1) ? q[counter-2] : 1'b0};
                    end
                    state <= 1;
                end
                1: begin  // Compute stage
                    q[counter] <= next_bit;
                    if (counter == 511) begin
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                    state <= 0;
                end
            endcase
        end
    end

endmodule