module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // FSM states
    localparam SEARCH  = 1'b0;
    localparam COLLECT = 1'b1;

    reg state;
    reg [1:0] count;  // counts how many bytes collected: 0 to 3
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= SEARCH;
            count     <= 2'd0;
            shift_reg <= 24'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            done <= 1'b0; // default done low

            case(state)
                SEARCH: begin
                    count <= 2'd0;
                    if (in[3]) begin
                        // Start byte found: load into MSB byte of shift_reg
                        shift_reg <= {in, 16'd0};
                        count <= 2'd1;
                        state <= COLLECT;
                    end
                end
                COLLECT: begin
                    // Shift in new byte from LSB side, pushing older bytes up
                    // shift_reg[23:8] <= previous shift_reg[15:0], shift_reg[7:0] <= in
                    shift_reg <= {shift_reg[15:0], in};
                    count <= count + 1;

                    if (count == 2'd2) begin
                        // Just shifted third byte in (count was 2 before increment)
                        done <= 1'b1;
                        out_bytes <= {shift_reg[15:0], in}; // the 3 bytes concatenated MSB to LSB
                        state <= SEARCH;
                    end
                end
                default: begin
                    state <= SEARCH;
                    count <= 2'd0;
                    shift_reg <= 24'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end
endmodule